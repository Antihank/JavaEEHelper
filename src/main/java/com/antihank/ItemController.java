package com.antihank;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by Antihank on 2017/5/6.
 */
@RestController
@Scope("request")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @RequestMapping(value = "next/{id}", method = RequestMethod.GET)
    public ResponseEntity next(@PathVariable(value = "id", required = false) Long id) {
        Item item = itemService.nextItem(id);
        return ResponseEntity.status(item == null ? HttpStatus.NOT_FOUND : HttpStatus.OK).body(item);
    }

    @RequestMapping(value = "previous/{id}", method = RequestMethod.GET)
    public ResponseEntity previous(@PathVariable(value = "id", required = false) Long id) {
        Item item = itemService.previousItem(id);
        return ResponseEntity.status(item == null ? HttpStatus.NOT_FOUND : HttpStatus.OK).body(item);
    }

    @RequestMapping(value = "random", method = RequestMethod.GET)
    public ResponseEntity random() {
        Item item = itemService.randomItem();
        return ResponseEntity.status(item == null ? HttpStatus.NOT_FOUND : HttpStatus.OK).body(item);
    }

    @RequestMapping(value = "add", method = RequestMethod.POST)
    public ResponseEntity add(Item item) {
        try {
            itemService.add(item);
            return ResponseEntity.status(HttpStatus.OK).body("添加完成");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    @RequestMapping(value = "update", method = RequestMethod.POST)
    public ResponseEntity update(Item item) {
        try {
            itemService.update(item);
            return ResponseEntity.status(HttpStatus.OK).body("修改完成");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }
}
