package com.antihank;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Random;

/**
 * Created by Antihank on 2017/5/6.
 */
@Service
public class ItemService {

    @Autowired
    private ItemMapper itemMapper;

    Item nextItem(Long id) {
        long l = itemMapper.selectCount(new Item());
        Item i = null;
        if (id == null || id == 0) {
            i = itemMapper.selectByPrimaryKey(1L);
        } else if (id < l) {
            //当前id小于总数
            i = itemMapper.selectByPrimaryKey(((long) (id + 1)));
        } else {
            //当前id等于总数
            i = itemMapper.selectByPrimaryKey(1L);
        }
        return i;
    }

    Item previousItem(Long id) {
        Item i = null;
        if (id == null || id == 0) {
            int count = itemMapper.selectCount(new Item());
            i = itemMapper.selectByPrimaryKey(((long) count));
        } else if (id == 1) {
            //当前id==1
            int count = itemMapper.selectCount(new Item());
            i = itemMapper.selectByPrimaryKey(((long) (count)));
        } else if (id > 1) {
            //当前id>1
            i = itemMapper.selectByPrimaryKey(((long) (id - 1)));
        }
        return i;
    }


    Item randomItem() {
        int bound = itemMapper.selectCount(new Item()) ;
        long id = new Random().nextInt(bound) + 1;
        return itemMapper.selectByPrimaryKey(id);
    }

    void add(Item item) {
        int id = itemMapper.selectCount(new Item()) + 1;
        item.setId(((long) id));
        itemMapper.insertSelective(item);
    }

    void update(Item item) {
        itemMapper.updateByPrimaryKeySelective(item);
    }
}
