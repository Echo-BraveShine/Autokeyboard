// MARK:// 弹框键盘封装  注意请勿在同一个VC多次使用
extension UIView {
    
    fileprivate struct RuntimeKeyboardKey{
        static let kFrameOriginYKey = UnsafeRawPointer.init(bitPattern: "kFrameOriginYKey".hashValue)
        static let kSpaceKeyboardKey = UnsafeRawPointer.init(bitPattern: "kSpaceKeyboardKey".hashValue)
    }
    
    fileprivate var frameOriginY: CGFloat {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKeyboardKey.kFrameOriginYKey!, "\(newValue)", .OBJC_ASSOCIATION_RETAIN)
        }
       
        get {
            let y = objc_getAssociatedObject(self, UIView.RuntimeKeyboardKey.kFrameOriginYKey!)
            if y == nil {
                return 0
            }else{
                
                let sy : String = y as! String
                return CGFloat(Float(sy)!)
            }
        }
    }
    
    /// 视图距离键盘的间距，在需要适配弹出键盘的view上使用
    var spaceKeyboard: CGFloat {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKeyboardKey.kSpaceKeyboardKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
            autoKeyboardShow()
        }
        get {
            let space = objc_getAssociatedObject(self, UIView.RuntimeKeyboardKey.kSpaceKeyboardKey!)
            if space == nil {
                return 0
            }else{
                return space as! CGFloat
            }
        }
    }
    
    
    fileprivate func autoKeyboardShow() {
        //防止重复添加
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        self.frameOriginY = self.y

        
        NotificationCenter.default.addObserver(self, selector:#selector(dd_keyboardWillShow(notif:)) , name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(dd_keyboardWillHiden(notif:)) , name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
  
    
    @objc fileprivate func dd_keyboardWillShow(notif : Notification)  {

        let info = notif.userInfo
        let value : CGRect = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        let y = (self.superview?.height)! - value.size.height - self.height - self.spaceKeyboard
        
        if y > self.y {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.y =  y
        }
        
    }
    @objc fileprivate func dd_keyboardWillHiden(notif : Notification)  {
        
        UIView.animate(withDuration: 0.2) {
            self.y = self.frameOriginY
        }
    }
}
