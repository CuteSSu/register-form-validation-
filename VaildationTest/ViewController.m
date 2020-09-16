//
//  ViewController.m
//  VaildationTest
//
//  Created by obigo on 2020/09/15.
//  Copyright © 2020 obigo. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define NUMBERS_ONLY @"1234567890"
#define GENDER_ONLY @"1234"

#define BIRTH_MAX 9
#define GENDER_MAX 2
#define TEL_MAX 12

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //비밀번호 필드 암호화
    password.secureTextEntry = YES;
    passwordCheck.secureTextEntry = YES;

    idEmail.delegate = self;
    password.delegate = self;
    passwordCheck.delegate = self;
    name.delegate=self;
    birth.delegate=self;
    gender.delegate=self;
    telNum.delegate=self;
    
    // 에러레이블 초기 설정
    pwLabel.hidden = YES;
    repwLabel.hidden = YES;
    idLabel.hidden = YES;
    emailLabel.hidden = YES;
    
    //중복확인 버튼 테두리 색깔 설정
    idDoudleCheck.layer.borderColor = [UIColor systemTealColor].CGColor;
    
    //스크롤뷰
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    UIView *mainView = self.view;
    self.view = scrollView;
    [scrollView addSubview:mainView];
    scrollView.contentSize = mainView.frame.size;
    scrollView.backgroundColor = mainView.backgroundColor;
    self.scrollView = scrollView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    // 빈부분 터치 시, 키보드 사라지기 dismiss keyboard when tap outside a text field
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

//이메일 정규식
- (BOOL)validateEmailWithString:(NSString*)email //아이디 이메일 형식확인
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 비밀번호 정규식 : 영문, 숫자, 특수문자 8-10자 이내
- (BOOL)checkPW:(NSString *)pw
{
    NSString *check = @"^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,10}$";
    NSRange match = [pw rangeOfString:check options:NSRegularExpressionSearch];
    
    if (NSNotFound == match.location){
        return NO;}
    return YES;
}

// 생년월일 정규식: 숫자, 8자리
- (BOOL)checkBirth:(NSString*)text{
    
    const char *tmp = [text cStringUsingEncoding:NSUTF8StringEncoding];
    if (text.length != strlen(tmp)){
        return NO;}
    
    NSString *check = @"^[0-9]{1,8}";
    NSRange match = [text rangeOfString:check options:NSRegularExpressionSearch];
    if (NSNotFound == match.location){
        return NO;}
    return YES;
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string {

    if(idEmail == theTextField){
        if(idEmail){
            emailLabel.hidden = NO;
            //아이디가 이메일 형식일때
            if([self validateEmailWithString:idEmail.text]){
                emailLabel.hidden = YES;
            }
        }
    }
    
    if(password == theTextField){
        if(password){
            pwLabel.hidden = NO;
            // 비밀번호 정규식 확인
            if([self checkPW:password.text]){
                pwLabel.hidden = YES;
            }
        }
    }
    
    if(passwordCheck == theTextField){
        if(passwordCheck){
            repwLabel.hidden = NO;
            NSLog(@"1번 %@, %@, %@",passwordCheck.text, theTextField.text,password.text);
            // 비밀번호 재확인
            if([theTextField.text isEqualToString:password.text]){
                NSLog(@"2번 %@, %@, %@",passwordCheck.text, theTextField.text,password.text);
                repwLabel.hidden = YES;
            }
        }
    }

    // 생일 0~9, 최대 8글자
    if(birth == theTextField){
        NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength < BIRTH_MAX));
    }
    
    // 성별 1~4, 최대 1글자
    if(gender == theTextField){
        NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:GENDER_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength < GENDER_MAX));
    }
    
    // 휴대폰 0~9, 최대 11글자
    if(telNum == theTextField){
        NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength < TEL_MAX));
    }
    
    return YES;
}

-(Boolean)fieldCheck{
    
    // 모든 항목들이 빈칸일 경우에 실패값 전송
    if([idEmail.text isEqual: @""]&&[password.text isEqual: @""]&&[passwordCheck.text isEqual: @""]&&[name.text isEqual: @""]&&[birth.text isEqual: @""]&&[gender.text isEqual: @""]&&[telNum.text isEqual: @""]){
        return true;
    }
    return false;
}
 
// 중복확인 버튼 눌렀을 때
- (IBAction)doubleCheck:(id)sender {

}

// 다음 버튼 눌렀을 때
- (IBAction)nextBtn:(id)sender {
    // 모든 항목이 체크 되지 않았으면
    if([self fieldCheck]){
        [self alertMessage:@"알림" :@"모든 항목들을 다 입력해주세요" :@"확인"];
    }
    
    // 비밀번호와 비밀번호 체크부분이 같지 않는 경우
    else if(password.text != passwordCheck.text){
        [self alertMessage:@"알림" :@"비밀번호가 맞지 않습니다." :@"확인"];
    }
    
    // 아이디 중복체크를 하지 않은 경우
    else if(NULL){
    }
    
    //모든 항목이 채크되었으면 회원가입 웹뷰로 이동
    else{
    }
    
}

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info        objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
- (void) keyboardWillHide:(NSNotification *) notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.view endEditing:YES];
}

-(void) alertMessage:(NSString *)alertTitle :(NSString *)message :(NSString *)actionTitle{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
