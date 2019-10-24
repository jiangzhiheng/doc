package atmsystem;

import java.util.Scanner;

public class TestMain {
    public static void main(String[] args) {
        AtmServices t = new AtmServices();
        Scanner input = new Scanner(System.in);
        System.out.println("Welcome!");
        System.out.println("请输入用户名");
        String username = input.nextLine();
        System.out.println("请输入密码");
        String password = input.nextLine();
        String loginResult = t.login(username,password);
        System.out.println(loginResult);
    }
}
