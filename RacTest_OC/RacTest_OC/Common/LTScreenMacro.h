//
//  ScreenMacro.h
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#ifndef LTScreenMacro_h
#define LTScreenMacro_h

#define ScreenW        ([UIScreen mainScreen].bounds.size.width)
#define ScreenH        ([UIScreen mainScreen].bounds.size.height)
#define ScreenSize     ([UIScreen mainScreen].bounds.size)
#define ScreenScale    ([UIScreen mainScreen].bounds.scale)

/// 以iphoneX为标准做适配
#define LTScaleW(width)   (width / ScreenW * 375.0)
#define LTScaleH(height)  (width / ScreenW * 812.0)


#endif /* ScreenMacro_h */
