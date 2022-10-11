package com.example;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    private List<Product> list = new ArrayList<Product>();

    public void createProducts() {
        list = List.of(
                new Product(1, "Skates", 10, 1000),
                new Product(2, "Skiis", 20, 2000),
                new Product(3, "Tennis Racquet", 30, 3000),
                new Product(3, "Shoes", 40, 4000),
                new Product(3, "Socks", 50, 5000),
                new Product(3, "Trees", 60, 6000),
                new Product(3, "Plants", 70, 7000),
                new Product(3, "PCs", 80, 8000),
                new Product(3, "Hoses", 90, 9000),
                new Product(3, "Tables", 10, 1000),
                new Product(3, "Chairs", 20, 2000),
                new Product(3, "TVs", 30, 3000),
                new Product(3, "Couches", 40, 4000),
                new Product(3, "Carpets", 50, 5000)
        );
    }

    // @RequestMapping("/")
    // String hello() {
    //     return {"Api":"products"};
    // }

    @RequestMapping("/products")
    List<Product> products() {
        createProducts();
        return list;
    }
}
