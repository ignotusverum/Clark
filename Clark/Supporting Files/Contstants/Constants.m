//
//  Constants.m
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/9/17.
//  Copyright © 2017 Clark. All rights reserved.
//

#import "Constants.h"

#ifdef C_MACRO_ENVIRONMENT
NSString * const HostName = C_MACRO_HOST_NAME;
NSString * const MacroEnviroment = C_MACRO_ENVIRONMENT;
NSString * const SegmentKey = C_MACRO_SEGMENT_KEY;
NSString * const StripeKey = C_MACRO_STRIPE_KEY;
NSString * const KickoffURL = C_KICKOFF_URL;
NSString * const KickoffKey = C_KICKOFF_KEY;
NSString * const OnboardingKey = C_MACRO_OBOARDING_KEY;
#else
NSString * const MacroEnviroment = @"Dev";
NSString * const HostName = @"manager-qa.hiclark.com/api/mobile";
NSString * const SegmentKey = @"KiyBWhQClkp9kMNWDHoHD4zYQY4ZUX5U";
NSString * const StripeKey = @"pk_test_wy3kwqAnFOHJ8pJPrjMqhUo3";
NSString * const KickoffURL = @"rve16sno45.execute-api.us-east-2.amazonaws.com/live";
NSString * const KickoffKey = @"qEhr5dmn9L2f4CA0OLjkA1BTTo9cd3VYKq7GJre6";
NSString * const OnboardingKey = @"ec13d697-aa85-4f2e-99a1-a80735a3779b";
#endif
