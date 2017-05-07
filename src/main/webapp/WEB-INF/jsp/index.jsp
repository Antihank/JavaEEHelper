<%--
  Created by IntelliJ IDEA.
  User: Antihank
  Date: 2017/5/6
  Time: 13:23
  To change this template use File | Settings | File Templates.
  
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set value="${pageContext.servletContext.contextPath}" var="ctx"/>
<!-- main JS libs -->
<script src="${ctx}/js/libs/modernizr.min.js"></script>
<script src="${ctx}/js/libs/jquery-1.10.0.js"></script>
<script src="${ctx}/js/libs/jquery-ui.min.js"></script>
<script src="${ctx}/js/libs/bootstrap.min.js"></script>
<script src="${ctx}/js/respond.min.js"></script>
<!-- Style CSS -->
<link href="${ctx}/css/bootstrap.css" media="screen" rel="stylesheet">
<link href="${ctx}/css/prettify.css" rel="stylesheet">
<link href="${ctx}/style.css" media="screen" rel="stylesheet">
<link href="${ctx}/css/docs.css" media="screen" rel="stylesheet">
<link rel="stylesheet" href="${ctx}/css/chosen.css">
<!-- scripts -->
<script src="${ctx}/js/general.js"></script>
<script src="${ctx}/general.js"></script>
<!-- custom input -->
<script src="${ctx}/js/jquery.customInput.js"></script>
<script type="text/javascript" src="${ctx}/js/custom.js"></script>
<!-- Visual Text Editor -->
<script src="${ctx}/js/nicEdit.js"></script>
<script src="${ctx}/js/jquery.chosen.min.js" type="text/javascript"></script>
<script src="${ctx}/js/jquery.powerful-placeholder.min.js"></script>
<html>
<head>
    <title>问答器</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <style>
        .nav li a {
            -moz-user-select: none;
        }

        #answer_div:hover {
            cursor: hand;
        }
    </style>
    <script>
        var currentItem = null;
        var isEdit = false;
        function clearInput() {
            $(".nicEdit-main").css("width", "424px");
            $("#question_add").val("");
            $(".nicEdit-main").html("");
        }
        function previous() {
            var id = currentItem == null ? "/0" : "/" + currentItem.id;
            $.get(
                    "${ctx}/previous" + id,
                    {},
                    put
            )
        }
        function next() {
            var id = currentItem == null ? "/0" : "/" + currentItem.id;
            $.get(
                    "${ctx}/next" + id,
                    {},
                    put
            )
        }
        function random() {
            $.get(
                    "${ctx}/random",
                    {},
                    put
            )
        }
        /**
         * 回显题目
         * @param data item对象
         */
        function put(data) {
            currentItem = data;
            $("#question").html(data.question);
            $("#answer").html("");
            $("#itemId").html(data.id);
            //可编辑
            $("#editBtn").slideDown(1000);
        }
        /**
         * 重载当前item
         */
        function reloadItem() {
            if (currentItem == null) {
                return;
            }
            var id = currentItem.id;
            $.get(
                    "${ctx}/next" + "/" + (id - 1),
                    {},
                    put
            );
        }
        /**
         * 编辑并回显
         */
        function edit() {
            if (currentItem == null) {
                $("#add_message").html("当前没有题目可以编辑");
                setTimeout(function () {
                    $("#add_message").html("");
                }, 3000)
                return;
            }
            //填充题目到编辑器
            var question = currentItem.question;
            var answer = currentItem.answer;
            $("#question_add").val(question);
            $(".nicEdit-main").html(answer);
            $("#demoModal").modal("show");
            isEdit = true;
        }
        /**
         * 提交编辑好的item
         */
        function update() {
            var question = $("#question_add").val();
            var answer = $(".nicEdit-main").html();
            var id = currentItem.id;
            $.post(
                    "${ctx}/update",
                    {"id": id, "question": question, "answer": answer},
                    function (data) {
                        $("#add_message").html(data);
                        setTimeout(function () {
                            cancelModal();
                            reloadItem();
                        }, 1000);
                    }
            )
        }
        function add() {
            //判断状态调用
            if (isEdit) {
                update();
                return;
            }
            var question = $("#question_add").val();
            var answer = $(".nicEdit-main").html();
            $.post(
                    "${ctx}/add",
                    {"question": question, "answer": answer},
                    function (data) {
                        clearInput();
                        $("#add_message").html(data);
                        setTimeout(function () {
                            $("#add_message").html("");
                        }, 3000)
                    }
            )
        }
        /**
         * 取消窗口事件
         */
        function cancelModal() {
            //修改时点击取消
            if (isEdit) {
                clearInput();
                isEdit = false;
            }
            $("#add_message").html("");
            $("#demoModal").modal("hide");
        }
        function openModal() {
            $("#demoModal").modal("show");
        }
        $(function () {
            // Text Editor
            bkLib.onDomLoaded(function () {
                var myNicEditor = new nicEditor({
                    buttonList: [
                        'bold',
                        'italic',
                        'underline',
                        'forecolor',
                        'left',
                        'center',
                        'right',
                        'justify'
                    ]
                });
                myNicEditor.setPanel('edit_buttons');
                myNicEditor.addInstance('answer_add');
            });
            setTimeout(function () {
                var nic_width = $('.nicEdit-panel').width();
                $('.nicEdit-container').css('width', nic_width);
                $('.nicEdit-main').css('width', nic_width - 24);
            }, 2000);
            $(window).resize(function () {
                var nic_width = $('.nicEdit-panel').width();
                $('.nicEdit-container').css('width', nic_width);
                $('.nicEdit-main').css('width', nic_width - 24);
            });
            //全局键盘监听
            $("#body_wrap").attr('tabindex', 1).keyup(function (event) {
                switch (event.keyCode) {
                    case 13:
                        random();
                        return;
                    case 37:
                        previous();
                        return;
                    case 39:
                        next();
                        return;
                    case 32:
                        if (currentItem != null)
                            $("#answer").html(currentItem.answer);
                        return;
                }
            });
            //灰化按钮
            $("#editBtn").hide();
            //显示答案
            $("#answer_div").click(function () {
                if (currentItem != null)
                    $("#answer").html(currentItem.answer);
            });
        })
    </script>
</head>
<body class="jumbotron">
<div id="body_wrap" class="body_wrap">
    <div class="container">
        <div class="row">
            <div class="col-sm-3">
                <div class="sidebar-demo hidden-print affix" role="complementary" data-spy="affix"
                     data-offset-top="200">
                    <h1 id="itemId" style="float: right"></h1>
                    <div style="clear: both;"></div>
                    <ul class="nav">
                        <li><a href="javascript:void(0)" ondragstart="return false" onclick="openModal()">增加题目</a>
                        </li>
                        <li><a id="editBtn" href="javascript:void(0)" ondragstart="return false"
                               onclick="edit()">修改题目</a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-sm-9">
                <div class="context-demo" role="main">
                    <div class="example">
                        <div class="example-code" style="padding: 27px;margin-bottom: 50px">
                            <h4 id="question">欢迎</h4>
                        </div>

                        <div id="answer_div" class="example-item">
                            <div style="font-size: large" id="answer"></div>
                        </div>
                    </div>
                    <div align="center">
                        <a href="javascript:void(0)" class="btn btn-left" onclick="previous()"
                           ondragstart="return false"><span>pre</span></a>
                        <a href="javascript:void(0)" id="randomBtn" ondragstart="return false"
                           class="btn btn-large btn-green" onclick="random()"><span>随机出题</span></a>
                        <a href="javascript:void(0)" class="btn btn-right" onclick="next()"
                           ondragstart="return false"><span>next</span></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" data-backdrop="static" id="demoModal">
    <div class="modal-dialog">
        <div class="add-comment styled boxed boxed-cream modal-content">
            <div class="add-comment-title gradient"><h3>添加题目</h3></div>
            <div class="comment-form">
                <form method="post" id="addForm" class="ajax_form">
                    <div class="form-inner">
                        <div class="field_text">
                            <label for="question_add" class="label_title">题目:</label>
                            <input type="text" name="question" id="question_add" value=""
                                   class="inputtext input_middle required"/>
                        </div>
                        <div class="clear"></div>
                        <div class="field_text field_textarea">
                            <div id="edit_buttons" class="edit_buttons gradient"></div>
                            <label for="answer_add" class="label_title">回答:</label>
                            <textarea cols="30" rows="10" name="answer" id="answer_add"
                                      class="textarea textarea_middle">
                            </textarea>
                        </div>
                        <div class="clear"></div>
                    </div>
                </form>
                <div class="rowSubmit">
                    <span id="add_message"></span>
                    <a class="btn btn-white" href="javascript:void(0)" onclick="clearInput()"><span>清空</span></a>
                    <a onclick="cancelModal()" href="javascript:void(0)"
                       class="link-reset btn btn-white"><span>取消</span></a>
                    <a class="btn" id="send" href="javascript:void(0)" onclick="add()"><span>提交</span></a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

</html>
