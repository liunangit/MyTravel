//
//  PublicHeader.h
//  Travel
//
//  Created by liunan on 14-5-31.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#ifndef Travel_PublicHeader_h
#define Travel_PublicHeader_h

#define kHideKeyBoardsNotification @"kHideKeyBoardsNotification"

////////////////汇率相关//////////////////
//默认汇率
#define kDefaultExchangeRateOfCNYtoJPY  16.29f

//请求汇率的url
#define kCurrentRequestURL  @"http://rate-exchange.appspot.com/currency?from=CNY&to=JPY"

////////////////天气相关//////////////////

//通过id请求天气的url
#define kWeatherCityIDRequestURL  @"http://api.openweathermap.org/data/2.5/weather?id="

//城市ID
#define kCityCodeTokyo  1850147
#define kCityCodeShenzhen  1795565
#define kCityCodeBeijing  1816670
#define kCityCodeHK     1819729
#define kCityCodeKyoto  1857910
#define kCityCodeOsaka  1850892

//通过经纬度请求天气的url
#define kWeatherCoordRequestURL  @"http://api.openweathermap.org/data/2.5/weather?"

//天气请求间隔
#define kWeatherRequestTimeInterval (10 * 60)

///////////////////////////////////////////

#endif
