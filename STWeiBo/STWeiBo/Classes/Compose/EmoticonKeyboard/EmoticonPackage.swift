//
//  Emoticons.swift
//  STWeiBo
//
//  Created by ST on 15/11/24.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

/// 表情包, 存储每一组表情数据
class EmoticonPackage: NSObject {
    /// 表情路径
    var id: String?
    /// 分组名称
    var groupName: String?
    /// 表情数组
    var emoticons: [Emoticon]?
    
    init(id: String) {
        self.id = id
    }
    
    ///  添加喜爱的表情
    func addFavoriteEmoticon(emoticon: Emoticon)
    {
        emoticons?.removeLast()
        
        // 1.判断数组中是否已经包含当前表情
        let contains = emoticons!.contains(emoticon)
        
        // 2.如果不包含就添加
        if !contains
        {
            // 添加新表情
            emoticons?.append(emoticon)
            print("添加一个表情")
        }
        
        // 3.根据 times 进行数组排序
        var results = emoticons?.sort({ (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        
        if !contains
        {
            // 如果有插入新的需要删除一个
            results!.removeLast()
        }
        
        // 5.重新设置数组
        emoticons = results
        
        emoticons?.append(Emoticon(isRemoveButton: true))
    }
    
    ///  加载表情包`数组`
    class func packages() -> [EmoticonPackage] {
        var list = [EmoticonPackage]()
        
        // 0. 设置最近的表情包
        let p = EmoticonPackage(id: "")
        p.groupName = "最近"
        // 追加表情
        p.appendEmptyEmoticons()
        list.append(p)
        
        
        // 1. 读取 emoticons.plist
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path)!
        let array = dict["packages"] as! [[String : AnyObject]]
        
        // 2. 遍历数组
        for d in array
        {
            // 2.1创建表情包,并初始化对应的路径
            let package = EmoticonPackage(id: d["id"] as! String)
            // 2.2加载表情数组
            package.loadEmoticons()
            // 追加空白模型
            package.appendEmptyEmoticons()
            // 2.3添加表情包
            list.append(package)
        }
        return list
    }
    ///  加载对应的表情数组
    private func loadEmoticons()
    {
        // 1.加载 id 路径对应的 info.plist
        let dict = NSDictionary(contentsOfFile: plistPath())!
        // 2.设置分组名
        groupName = dict["group_name_cn"] as? String
        // 3.获取表情数组
        let array = dict["emoticons"] as! [[String: String]]
        
        // 实例化表情数组
        emoticons = [Emoticon]()
        // 4.遍历加载表情数组
        var index = 0
        for d in array
        {
            emoticons?.append(Emoticon(id: id, dict: d))
            index++
            if index == 20 {
                // 插入删除按钮
                emoticons?.append(Emoticon(isRemoveButton: true))
                index = 0
            }
        }
    }
    
    ///  追加空白按钮，方便界面布局，如果一个界面的图标不足20个，补足，最后添加一个删除按钮
    private func appendEmptyEmoticons() {
        
        if emoticons == nil
        {
            emoticons = [Emoticon]()
        }
        
        let count = emoticons!.count % 21
        if count > 0 || emoticons!.count == 0
        {
            for _ in count..<20
            {
                // 追加空白按钮
                emoticons?.append(Emoticon(isRemoveButton: false))
            }
            // 追加一个删除按钮
            emoticons?.append(Emoticon(isRemoveButton: true))
        }
    }
    
    ///  返回 info.plist 的路径
    private func plistPath() -> String {
        return (EmoticonPackage.bundlePath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent("info.plist")
    }
    
    /// 返回表情包路径
    private class func bundlePath() -> NSString {
        return (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
    }
}

/// 表情模型
class Emoticon: NSObject {
    
    /// 用户使用次数
    var times = 0
    /// 表情路径
    var id: String?
    /// 表情文字，发送给新浪微博服务器的文本内容
    var chs: String?
    /// 表情图片，在 App 中进行图文混排使用的图片
    var png: String?
    /// UNICODE 编码字符串
    var code: String?
        {
        didSet{
            // 1. 扫描器，可以扫描指定字符串中特定的文字
            let scanner = NSScanner(string: code!)
            // 2. 扫描整数 Unsafe`Mutable`Pointer 可变的指针，要修改参数的内存地址的内容
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            
            // 3. 生成字符串：UNICODE 字符 -> 转换成字符串
            emoji = "\(Character(UnicodeScalar(result)))"
        }
    }
    /// emoji 字符串
    var emoji: String?
    
    /// 图片的完整路径 - 计算型属性，只读属性
    var imagePath: String?
        {
            return png == nil ? nil : (EmoticonPackage.bundlePath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
    }
    
    /// 是否删除按钮标记
    var removeButton = false
    
    init(isRemoveButton: Bool) {
        removeButton = isRemoveButton
    }
    
    init(id: String?,dict: [String: String])
    {
        super.init()
        self.id = id
        // 使用 KVC 设置属性之前，必须调用 super.init
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        return "chs = \(chs), removeButton = \(removeButton)"
    }

}