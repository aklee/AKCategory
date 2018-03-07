//
//  Regex.h
//
//  Created by ak on 15/7/14.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#define kCheckEmail @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

//验证手机号码：”^1[3|4|5|7|8][0-9]\\d{8}$”；
#define kCheckMobileNo @"^((13[0-9])|(14[57])|(15[^4,\\D])|(17[678])|(18[0-9]))\\d{8}$"
#define kCheckPersonalID @"\\d{14}[0-9a-zA-Z]|\\d{17}[0-9a-zA-Z]"
#define kCheckPersonalID2 @"^[0-9xX]{0,18}"
#define kCheckPersonalName @"[\u4e00-\u9fa5]" 
#define kCheckNumber @"^[1-9]\\d*$"

#define kCheckTradePwd @"\\d{6}"
#define kCheckLoginPwd @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"

//精确到小数点2位
#define kCheckDecimal @"^[-]?([1-9]{1}[0-9]{0,}([.][0-9]{0,2})?|0([.][0-9]{0,2})?|[.][0-9]{1,2})$"

//^((?=.*?\d)(?=.*?[A-Za-z])|(?=.*?\d)(?=.*?[符号])|(?=.*?[A-Za-z])(?=.*?[符号]))[\dA-Za-z符号]+$


#define kCheckNumber2 @"^[0-9]\\d*$"

#define kSingleLetter @"^[A-Za-z]+$"
//匹配密码强度为，强度为中
#define kLoginPwdStrengthMiddle @"(?!^\\d+$)(?!^[a-zA-Z]+$)(?!^[~!@#$%^&*()\\-+_=`{}\\]\\[|\\\\,.><'\"?/;:]+$).{8,12}"


//匹配密码强度为，强度为强1：两中组合
#define kLoginPwdStrengthHigh1 @"(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[~!@#$%^&*()+\\-`_{},.=\\\\|'\"\\]?/><;:\\[])[0-9a-zA-Z~!@#$%^&*()\\-+`_{},.=\\\\|'\"\\]?/><;:\\[]{8,}"

//匹配密码强度为，强度为强2：三中组合
#define kLoginPwdStrengthHigh2 @"(?!^\\d+$)(?!^[a-zA-Z]+$)(?!^[~!@#$%^&*()\\-+_=`{}\\]\\[|\\\\,.><'\"?/;:]+$).{12,}"






