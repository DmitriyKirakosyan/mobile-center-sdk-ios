#import "MSAnalyticsAuthenticationProviderInternal.h"
#import "MSTestFrameworks.h"
#import "MSTicketCache.h"
#import "MSUtility+StringFormatting.h"

@interface MSAnalyticsAuthenticationProviderTests : XCTestCase

@property(nonatomic) MSAnalyticsAuthenticationProvider *sut;

@property(nonatomic) NSDate *today;

@property(nonatomic) NSString *ticketKey;

@property(nonatomic) NSString *token;

@end

@implementation MSAnalyticsAuthenticationProviderTests

- (void)setUp {
  [super setUp];

  self.today = [NSDate date];
  self.ticketKey = @"ticketKey1";
  self.token = @"authenticationToken";
  id mockDelegate = OCMProtocolMock(@protocol(MSAnalyticsAuthenticationProviderDelegate));
  OCMStub([mockDelegate acquireTokenWithCompletionHandler:([OCMArg invokeBlockWithArgs:self.token, self.today, nil])]);
  self.sut = [[MSAnalyticsAuthenticationProvider alloc]
              initWithAuthenticationType:MSAnalyticsAuthenticationTypeMsaDelegate
              ticketKey:self.ticketKey
              delegate:mockDelegate];
  self.sut = [self createAuthenticationProviderWithTicketKey:self.ticketKey
                                                    delegate:mockDelegate];
}

- (void)tearDown {
  [super tearDown];

  self.sut = nil;
}

- (MSAnalyticsAuthenticationProvider *)
createAuthenticationProviderWithTicketKey:(NSString *)ticketKey
                                 delegate:
                                     (id<MSAnalyticsAuthenticationProviderDelegate>)
                                         delegate {

  return [[MSAnalyticsAuthenticationProvider alloc]
      initWithAuthenticationType:MSAnalyticsAuthenticationTypeMsaCompact
                       ticketKey:ticketKey
                        delegate:delegate];
}

- (void)testInitialization {

  // Then
  XCTAssertNotNil(self.sut);
  XCTAssertEqual(self.sut.type, MSAnalyticsAuthenticationTypeMsaCompact);
  XCTAssertNotNil(self.sut.ticketKey);
  XCTAssertNotNil(self.sut.ticketKeyHash);
  XCTAssertTrue([self.sut.ticketKeyHash
      isEqualToString:[MSUtility sha256:@"ticketKey1"]]);
  XCTAssertNotNil(self.sut.delegate);
}

- (void)testExpiryDateIsValid {

  // If
  id mockDelegate =
      OCMProtocolMock(@protocol(MSAnalyticsAuthenticationProviderDelegate));
  NSTimeInterval plusDay = (24 * 60 * 60);
  OCMStub([mockDelegate
           acquireTokenWithCompletionHandler:([OCMArg invokeBlockWithArgs:self.token,
                                               [self.today dateByAddingTimeInterval:plusDay],
                                               nil])]);
  self.sut = [self createAuthenticationProviderWithTicketKey:self.ticketKey
                                                    delegate:mockDelegate];
  id sutMock = OCMPartialMock(self.sut);

  // When
  XCTestExpectation *expection =
      [self expectationWithDescription:@"Expiry date is valid"];
  [self.sut acquireTokenAsync];
  dispatch_async(dispatch_get_main_queue(), ^{
    [expection fulfill];
  });

  [self waitForExpectationsWithTimeout:1
                               handler:^(NSError *error) {
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@",
                                           error);
                                 }

                                 // Then
                                 OCMReject([sutMock acquireTokenAsync]);
                                 [self.sut checkTokenExpiry];
                                 OCMVerifyAll(sutMock);
                               }];
}

- (void)testExpiryDateIsExpired {
  
  // If
  id mockDelegate =
  OCMProtocolMock(@protocol(MSAnalyticsAuthenticationProviderDelegate));
  NSTimeInterval minusDay = -(24 * 60 * 60);
  OCMStub([mockDelegate
           acquireTokenWithCompletionHandler:([OCMArg invokeBlockWithArgs:self.token,
                                               [self.today dateByAddingTimeInterval:minusDay],
                                               nil])]);
  self.sut = [self createAuthenticationProviderWithTicketKey:self.ticketKey
                                                    delegate:mockDelegate];
  id sutMock = OCMPartialMock(self.sut);

  // When
  XCTestExpectation *expection =
      [self expectationWithDescription:@"Expiry date is expired"];
  [self.sut acquireTokenAsync];
  dispatch_async(dispatch_get_main_queue(), ^{
    [expection fulfill];
  });

  [self waitForExpectationsWithTimeout:1
                               handler:^(NSError *error) {
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@",
                                           error);
                                 }

                                 // Then
                                 [self.sut checkTokenExpiry];
                                 OCMVerify([sutMock acquireTokenAsync]);
                               }];
}

- (void)testCompletionHandlerIsCalled {

  // If
  id mockDelegate =
      OCMProtocolMock(@protocol(MSAnalyticsAuthenticationProviderDelegate));
  OCMStub([mockDelegate
      acquireTokenWithCompletionHandler:([OCMArg invokeBlockWithArgs:self.token,
                                                                     self.today,
                                                                     nil])]);
  self.sut = [[MSAnalyticsAuthenticationProvider alloc]
      initWithAuthenticationType:MSAnalyticsAuthenticationTypeMsaCompact
                       ticketKey:self.ticketKey
                        delegate:mockDelegate];

  // When
  XCTestExpectation *expection =
      [self expectationWithDescription:@"Completion handler is called"];
  [self.sut acquireTokenAsync];
  dispatch_async(dispatch_get_main_queue(), ^{
    [expection fulfill];
  });
  [self waitForExpectationsWithTimeout:1
                               handler:^(NSError *error) {
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@",
                                           error);
                                 }

                                 // Then
                                 XCTAssertTrue([self.sut.expiryDate
                                     isEqualToDate:self.today]);
                                 NSString *savedToken =
                                     [[MSTicketCache sharedInstance]
                                         ticketFor:self.sut.ticketKeyHash];
                                 NSString *tokenWithPrefixString = [NSString
                                     stringWithFormat:@"p:%@", self.token];
                                 XCTAssertTrue([savedToken
                                     isEqualToString:tokenWithPrefixString]);
                               }];
}

- (void)testCompletionHandlerIsCalledForMSADelegateType {

  // If
  id mockDelegate =
      OCMProtocolMock(@protocol(MSAnalyticsAuthenticationProviderDelegate));
  OCMStub([mockDelegate
      acquireTokenWithCompletionHandler:([OCMArg invokeBlockWithArgs:self.token,
                                                                     self.today,
                                                                     nil])]);
  self.sut = [[MSAnalyticsAuthenticationProvider alloc]
      initWithAuthenticationType:MSAnalyticsAuthenticationTypeMsaDelegate
                       ticketKey:self.ticketKey
                        delegate:mockDelegate];

  // When
  XCTestExpectation *expection =
      [self expectationWithDescription:@"Completion handler is called"];
  [self.sut acquireTokenAsync];
  dispatch_async(dispatch_get_main_queue(), ^{
    [expection fulfill];
  });
  [self waitForExpectationsWithTimeout:1
                               handler:^(NSError *error) {
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@",
                                           error);
                                 }

                                 // Then
                                 XCTAssertTrue([self.sut.expiryDate
                                     isEqualToDate:self.today]);
                                 NSString *savedToken =
                                     [[MSTicketCache sharedInstance]
                                         ticketFor:self.sut.ticketKeyHash];
                                 NSString *tokenWithPrefixString = [NSString
                                     stringWithFormat:@"d:%@", self.token];
                                 XCTAssertTrue([savedToken
                                     isEqualToString:tokenWithPrefixString]);
                               }];
}

@end
