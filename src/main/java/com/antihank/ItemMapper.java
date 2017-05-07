package com.antihank;

import org.springframework.stereotype.Component;
import tk.mybatis.mapper.common.Mapper;
/**
 * Created by Antihank on 2017/5/6.
 */
@Component
@org.apache.ibatis.annotations.Mapper
public interface ItemMapper extends Mapper<Item> {
}
