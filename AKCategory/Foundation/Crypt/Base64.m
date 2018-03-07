//
//  Copyright (c) 2013, Benjamin Borbe <bborbe@rocketnews.de>
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above
//    copyright notice, this list of conditions and the following
//    disclaimer in the documentation and/or other materials provided
//    with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "Base64.h"

@implementation Base64

static const char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

static const char base64DecodingTable[] =
{
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
    99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
    99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
};

+ (NSString*)encode:(NSData*)data {
    if (data == nil)
    {
        return nil;
    }
    NSUInteger dlength = [data length];
    if (dlength == 0)
    {
        return @"";
    }
    unsigned char input[3], output[4];
    const unsigned char* raw = [data bytes];
    NSMutableString* result = [[NSMutableString alloc] init];
    NSUInteger pos = 0;
    while (pos < dlength)
    {
        unsigned int read = 1;
        unsigned int write = 2;
        input[0] = raw[pos++];
        if (pos < dlength)
        {
            input[1] = raw[pos++];
            read = 2;
            write = 3;
        }
        else
        {
            input[1] = 0;
        }
        if (pos < dlength)
        {
            input[2] = raw[pos++];
            read = 3;
            write = 4;
        }
        else
        {
            input[2] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        for (int i = 0; i < write; i++)
        {
            [result appendString:[NSString stringWithFormat:@"%c", base64EncodingTable[output[i]]]];
        }
        switch (read)
        {
            case 1:
                [result appendString:@"=="];
                break;

            case 2:
                [result appendString:@"="];
                break;
        }
    }
    return result;
}

+ (NSString*)encodeString:(NSString*)string
{
    if (string == nil)
    {
        return nil;
    }
    NSUInteger slength = [string length];
    if (slength == 0)
    {
        return @"";
    }
    const char* data = [string UTF8String];
    return [Base64 encode:[NSData dataWithBytes:data length:slength]];
}

+ (NSData*)decode:(NSString*)base64string
{
    if (base64string == nil)
    {
        return nil;
    }
    NSUInteger slength = [base64string length];
    if (slength == 0)
    {
        return [[NSData alloc] init];
    }
    NSUInteger read;
    char c;
    unsigned char input[4], output[3];
    const char* raw = [base64string UTF8String];
    NSMutableData* data = [[NSMutableData alloc] init];
    unsigned int pos = 0;
    while (pos < slength)
    {
        input[0] = base64DecodingTable[raw[pos++]];
        input[1] = base64DecodingTable[raw[pos++]];
        c = raw[pos++];
        read = 1;
        if (c == '=')
        {
            input[2] = 0;
        }
        else
        {
            input[2] = base64DecodingTable[c];
            read = 2;
        }
        c = raw[pos++];
        if (c == '=')
        {
            input[3] = 0;
        }
        else
        {
            input[3] = base64DecodingTable[c];
            read = 3;
        }
        output[0] = ((input[0] << 2) & 0xFC) | ((input[1] >> 4) & 0x03);
        output[1] = ((input[1] << 4) & 0xF0) | ((input[2] >> 2) & 0x0F);
        output[2] = ((input[2] << 6) & 0xC0) | ((input[3] >> 0 & 0x3F));
        [data appendBytes:output length:read];
    }
    return data;
}

+ (NSString*)decodeString:(NSString*)string
{
    if (string == nil)
    {
        return nil;
    }
    NSUInteger slength = [string length];
    if (slength == 0)
    {
        return @"";
    }
    NSData* data = [Base64 decode:string];
    NSString*str= [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding]
    return str;
}




+ (NSData *)Base64EncodeWithChars:(const char*)pInBuffer length:(int)length
{
    if(pInBuffer == nil)
        return nil;
    
    unsigned int iTest;
    
    int nSize = length;
    
    char* pOutBuffer=malloc(nSize/3*4+5);//new char[nSize/3*4+5];
    memset(pOutBuffer, 0, nSize/3*4+5);//ZeroMemory(pOutBuffer,nSize/3*4+5);
    
    for(int i=0;i<nSize / 3;i++)
    {
        iTest = (unsigned char) *pInBuffer++;
        iTest = iTest << 8;
        
        iTest = iTest | (unsigned char) *pInBuffer++;
        iTest = iTest << 8;
        
        iTest = iTest | (unsigned char) *pInBuffer++;
        
        //以4 byte倒序写入输出缓冲
        pOutBuffer[3] = base64EncodingTable[iTest & 0x3F];
        iTest = iTest >> 6;
        pOutBuffer[2] = base64EncodingTable[iTest & 0x3F];
        iTest = iTest >> 6;
        pOutBuffer[1] = base64EncodingTable[iTest & 0x3F];
        iTest = iTest >> 6;
        pOutBuffer[0] = base64EncodingTable[iTest];
        pOutBuffer+=4;
    }
    
    //设置尾部
    switch (nSize % 3)
    {
        case 0:
            break;
        case 1:
            iTest = (unsigned char) *pInBuffer;
            iTest = iTest << 4;
            pOutBuffer[1] = base64EncodingTable[iTest & 0x3F];
            iTest = iTest >> 6;
            pOutBuffer[0] = base64EncodingTable[iTest];
            pOutBuffer[2] = '='; //用'='也就是64码填充剩余部分
            pOutBuffer[3] = '=';
            break;
        case 2:
            iTest = (unsigned char) *pInBuffer++;
            iTest = iTest << 8;
            iTest = iTest | (unsigned char) *pInBuffer;
            iTest = iTest << 2;
            pOutBuffer[2] = base64EncodingTable[iTest & 0x3F];
            iTest = iTest >> 6;
            pOutBuffer[1] = base64EncodingTable[iTest & 0x3F];
            iTest = iTest >> 6;
            pOutBuffer[0] = base64EncodingTable[iTest];
            pOutBuffer[3] = '='; // Fill remaining byte.
            break;
    }
    pOutBuffer -= nSize/3*4;
    
    NSData * data = [[NSData alloc] initWithBytesNoCopy:pOutBuffer length:(nSize+2)/3*4 freeWhenDone:YES];
    //	NSData * data = [NSData dataWithBytesNoCopy:pOutBuffer length:(nSize+2)/3*4 freeWhenDone:YES];
    
    //	return [data autorelease];
    return data;
}

+ (NSData *)Base64DecodeWithChars:(const char*)pInBuffer
{
    //ASSERT(lpszSrc != NULL && AfxIsValidString(lpszSrc));
    if(pInBuffer == nil)
        return nil;
    
    const int nSrcCount=strlen(pInBuffer);//(int)_tcslen(lpszSrc);
    int nSize=nSrcCount/4*3;
    if(pInBuffer[nSrcCount-1]=='=')
        nSize--;
    if(pInBuffer[nSrcCount-2]=='=')
        nSize--;
    //	char* pOutBuffer=new char[nSize+3];
    //	ZeroMemory(pOutBuffer,nSize+3);
    char* pOutBuffer = malloc(nSize+3);
    memset(pOutBuffer, 0, nSize+3);
    
    //char* pInBuffer = lpszSrc;
    int iTest,iPack=0;
    for(int i=0;i<nSize/3 ;i++)
    {
        for(int j=0;j<4;j++)
        {
            iTest = base64DecodingTable[*pInBuffer]; // Read from InputBuffer.
            pInBuffer++;
            //InPtr++;
            if (iTest == 0xFF)
            {
                j--;
                continue; //读到255非法字符
            }
            iPack = iPack << 6 ;
            iPack = iPack | iTest ;
        }
        pOutBuffer[2] = iPack;
        iPack = iPack >> 8;
        pOutBuffer[1] = iPack;
        iPack = iPack >> 8;
        pOutBuffer[0] = iPack;
        //准备写入后3位
        pOutBuffer+= 3;
        iPack = 0;
    }
    switch(nSize%3)
    {
        case 1:
            iTest = base64DecodingTable[*pInBuffer]; // Read from InputBuffer.
            pInBuffer++;
            if (iTest != 0xFF)
            {
                iPack = iPack << 6 ;
                iPack = iPack | iTest ;
            }
            iTest = base64DecodingTable[*pInBuffer]; // Read from InputBuffer.
            if (iTest != 0xFF)
            {
                iPack = iPack << 6 ;
                iPack = iPack | iTest ;
            }
            iPack = iPack >> 4;
            pOutBuffer[0] = iPack;
            pOutBuffer++;
            break;
        case 2:
            iTest = base64DecodingTable[*pInBuffer]; // Read from InputBuffer.
            pInBuffer++;
            if (iTest != 0xFF)
            {
                iPack = iPack << 6 ;
                iPack = iPack | iTest ;
            }
            iTest = base64DecodingTable[*pInBuffer]; // Read from InputBuffer.
            pInBuffer++;
            if (iTest != 0xFF)
            {
                iPack = iPack << 6 ;
                iPack = iPack | iTest ;
            }
            iTest = base64DecodingTable[*pInBuffer]; // Read from InputBuffer.
            if (iTest != 0xFF)
            {
                iPack = iPack << 6 ;
                iPack = iPack | iTest ;
            }
            iPack = iPack >> 2;
            pOutBuffer[1] = iPack;
            iPack = iPack >> 8;
            pOutBuffer[0] = iPack;
            pOutBuffer+=2;
            break;
        default:
            break;
    }
    pOutBuffer-=nSize;
    pOutBuffer[nSize]='\0';
    
    
    return [NSData dataWithBytesNoCopy:pOutBuffer length:nSize freeWhenDone:YES];
}

@end
