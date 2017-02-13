// AFNetworking.h
//
// Copyright (c) 2013 AFNetworking (http://afnetworking.com/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <Availability.h>

#ifndef _AFNETWORKING_
    #define _AFNETWORKING_

    #import "AFURLRequestSerialization.h"
    #import "AFURLResponseSerialization.h"
    #import "AFSecurityPolicy.h"
    #import "AFNetworkReachabilityManager.h"

    #import "AFURLConnectionOperation.h"
    #import "AFHTTPRequestOperation.h"
    #import "AFHTTPRequestOperationManager.h"

#if ( ( defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090) || \
      ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 ) )
    #import "AFURLSessionManager.h"
    #import "AFHTTPSessionManager.h"
#endif


#define KUCHAHEADER @"http://115.28.49.84:8889/coolchat-webservices-1.0-SNAPSHOT"

//用户注册
#define KUCHAUSERURL @"/profile"

//获取accessToken
#define KUCHATOKEN @"/oauth/token"

//更新用户头像
#define KUCHACHANGESELFPHOTO @"/profile/self/photo"


//上传
#define KUCHAUPLOAD @"/upload"

//发表文章
#define KUCHAWENZHANG @"/post"

//上传图片
#define KUCHAPOSTPHOTO @"/upload/image"

//上传声音
#define KUCHAPOSTVOICE @"/upload/voice"

//获取文章 - 所有
#define KUCHAALLWENZHANG @"/post?page=0&size=10"

//获取文章 - 自己
#define KUCHASELFWENZHANG @"/post/self?page=0&size=5"

//获取文章 - 关注者
#define KUCHAFOLLOWEDWENZHANG @"/post/followed?page=0&size=5"


//订阅
#define KUCHAFOLLOW @"/follow"

//我订阅的
#define KUCHAFOLLOWED @"/followed"
//订阅数
#define KUCHAFOLLOWEDCOUNT @"/followed_count"
//订阅的人id
#define KUCHAFOLLOWED_ID @"/followed_id"



//订阅我的
#define KUCHAFOLLOWER @"/follower"
//粉丝数
#define KUCHAFOLLOWERCOUNT @"/follower_count"


//点赞
#define KUCHAENJOY @"/post/like"

//我赞过的
#define KUCHAMYENJOY @"/like_post"

//评论
#define KUCHACOMMENT @"/comment"

//获取对自己文章的评论
#define KUCHAGETCOMMENT @"/comment/follower"


//auv分类
#define KUCHAAUVKIND @"/title"

#define KUCHAAUV @"/auv"
//auv点赞
#define KUCHAAUVLIKES @"/auv/likes"

//已读减一
#define KUCHAAUVREAD @"/auv/read"


//学校
#define KUCHASCHOOL @"/organization"


//简历
#define KUCHAJIANLI @"/experience"



/**
 *  用户
 *  profile/{id}
 */

/**
 *  文章
 *  profile/{id}/post?page={num1}&size={num2}]]
 */







#endif /* _AFNETWORKING_ */
