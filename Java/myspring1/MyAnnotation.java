package myspring1;

import java.lang.annotation.*;

@Target({ElementType.FIELD,ElementType.CONSTRUCTOR,ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Inherited

public @interface MyAnnotation {

    String[] value() default "Martin";  //default "Martin" 默认方法--->属性

}

