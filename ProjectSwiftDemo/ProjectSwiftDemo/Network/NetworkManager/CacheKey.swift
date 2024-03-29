//
//  CacheKey.swift
//
//  Created by 张书孟 on 2018/8/24.
//  Copyright © 2018年 ZSM. All rights reserved.
//

import Cache

/// 将参数字典转换成字符串后md5
func cacheKey(_ url: String, _ params: Dictionary<String, Any>?, _ dynamicParams: Dictionary<String, Any>?) -> String {
    guard let params = params else {
        return MD5(url)
    }
    guard let dynamicParams = dynamicParams else {
        if let stringData = try? JSONSerialization.data(withJSONObject: params, options: []),
            let paramString = String(data: stringData, encoding: String.Encoding.utf8) {
            let str = "\(url)" + "\(paramString)"
            return MD5(str)
        } else {
            return MD5(url)
        }
    }
    /// `params`中过滤掉`dynamicParams`中的参数
    let filterParams = params.filter { (key, _) -> Bool in
        return dynamicParams.contains(where: { (key1, _) -> Bool in
            return key != key1
        })
    }
    guard let stringData = try? JSONSerialization.data(withJSONObject: filterParams, options: []),
        let paramString = String(data: stringData, encoding: String.Encoding.utf8) else {
            return MD5(url)
    }
    let str = "\(url)" + "\(paramString)"
    return MD5(str)
}
