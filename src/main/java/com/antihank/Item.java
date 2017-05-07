package com.antihank;

import javax.persistence.*;

/**
 * Created by Antihank on 2017/5/6.
 */
@Table(name = "tb_item")
public class Item {
    @Id
    private Long id;
    @Column(name = "question")
    private String question;
    @Column(name = "answer")
    private String answer;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}
