package com.ssafy.reslow.domain.product.dto;

import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.entity.ProductImage;
import java.time.LocalDateTime;
import java.util.List;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductListResponse {

    private String title;
    private int price;
    private Long productNo;
    private Long memberNo;
    private LocalDateTime datetime;
    private String image;
    private boolean myHeart;
    private Long likeCount;

    public static ProductListResponse of(Product product, List<ProductImage> list) {
        return ProductListResponse.builder()
            .productNo(product.getNo())
            .memberNo(product.getMember().getNo())
            .datetime(product.getCreatedDate())
            .price(product.getPrice())
            .title(product.getTitle())
            .image(list.isEmpty() ? null : list.get(0).getUrl())
            .build();
    }

    public void setLike(boolean myHeart, Long likeCount) {
        this.likeCount = likeCount;
        this.myHeart = myHeart;
    }

    public static ProductListResponse of(Product product, Long likeCount) {
        return ProductListResponse.builder()
            .productNo(product.getNo())
            .datetime(product.getCreatedDate())
            .price(product.getPrice())
            .title(product.getTitle())
            .likeCount(likeCount)
            .image(product.getProductImages().isEmpty() ? null
                : product.getProductImages().get(0).getUrl())
            .build();
    }
}
