<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" +request.getServerPort()+ request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		getActivity();

		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/activity/saveRemark.do",
				data: {
					"noteContent":$("#remark").val(),
					"activityId":"${param.id}"
				},
				dataType: "json",
				type: "post",
				success:function (data) {
					if (data.success){
						alert("保存成功！");
						$("#remark").val("");
						//$("#cancelAndSaveBtn").css("display","none");
						getRemarkList();
					}else {
						alert("保存失败！")
					}
				}
			})
		});

		getRemarkList();

        $("#editBtn").click(function () {
            $.ajax({
                url:"workbench/activity/editActivity.do",
                data:{
                    "id":"${param.id}"
                },
                dataType:"json",
                type:"post",
                success:function (data) {
                    $("#edit-owner").append("<option></option>");
                    $.each(data.userList,function (i,n) {
                        $("#edit-owner").append("<option value='"+ n.id +"'>"+ n.name +"</option>")
                    });
                    $("#edit-id").val(data.activity.id);
                    $("#edit-owner").val(data.activity.owner);
                    $("#edit-name").val(data.activity.name);
                    $("#edit-startTime").val(data.activity.startDate);
                    $("#edit-endTime").val(data.activity.endDate);
                    $("#edit-cost").val(data.activity.cost);
                    $("#edit-description").val(data.activity.description);

                    $(".time").datetimepicker({
                        minView: "month",
                        language:  'zh-CN',
                        format: 'yyyy-mm-dd',
                        autoclose: true,
                        todayBtn: true,
                        pickerPosition: "bottom-left"
                    });

                    $("#editActivityModal").modal("show");
                }
            })
	});
        $("#updateBtn").click(function () {
            if (confirm("您确定要更新您刚刚修改的内容嘛？")){
                $.ajax({
                    url:"workbench/activity/updateActivity.do",
                    data:{
                        "id":$("#edit-id").val(),
                        "owner":$("#edit-owner").val(),
                        "name":$("#edit-name").val(),
                        "startDate":$("#edit-startTime").val(),
                        "endDate":$("#edit-endTime").val(),
                        "cost":$("#edit-cost").val(),
                        "description":$("#edit-description").val()
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data) {
                        if (data.success){
                            $("#editActivityModal").modal("hide");
                            getActivity();
                        }else {
                            alert("修改失败！")
                        }
                    }
                })
            }
        });
        $("#updateRemarkBtn").click(function () {
            if (confirm("您确定要修改嘛？")){
                $.ajax({
                    url:"workbench/activity/updateRemark.do",
                    data:{
                        "id":$("#editRemark-id").val(),
                        "noteContent":$("#noteContent").val()
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data) {
                        if (data.success){
                            $("#editRemarkModal").modal("hide");
                            $.get("workbench")
                            getRemarkList();
                        }else {
                            alert("修改失败！");
                        }
                    }
                })
            }
        })
    });

	function getRemarkList() {
		$.ajax({
			url:"workbench/activity/getRemark.do",
			data:{
				"activityId":"${param.id}"
			},
			dataType:"json",
			type:"post",
			success:function (data) {
				let html ="";
				$.each(data.remarkList,function (i,n) {
					html += '<div class="remarkDiv" id="'+ n.id +'" style="height: 60px;">';
					html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+ n.noteContent +'</h5>';
					html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>'+ data.activity.name +'</b> <small style="color: gray;"> ';
					html += (n.editFlag==="0"?n.createTime:n.editTime) +' 由' + (n.editFlag==="0"?n.createBy:n.editBy) + '</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" onclick="editRemark(`' + n.id + '`)"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" onclick="deleteRemark(`' + n.id + '`)"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '</div>'+ '</div>'+ '</div>';
				});
				$("div[class=remarkDiv]").remove();
				$("#remarkDiv").before(html);
				$("#remarkBody").on("mouseover",".remarkDiv",function(){
					$(this).children("div").children("div").show();
				});
				$("#remarkBody").on("mouseout",".remarkDiv",function(){
					$(this).children("div").children("div").hide();
				});

                $("#remarkBody").on("mouseover",".glyphicon",function () {
                    $(this).css("color","#FF0000");
                });
                $("#remarkBody").on("mouseout",".glyphicon",function () {
                    $(this).css("color","#E6E6E6");
                })

				//alert($("div[name=remarkDiv]").length);

			}
		})

	}
	function deleteRemark(remarkId) {
	    if (confirm("您确认要删除此备注嘛？")){
            $.ajax({
                url:"workbench/activity/deleteRemark.do",
                data:{
                    id:remarkId
                },
                dataType:"json",
                type:"post",
                success:function (data) {
                    if (data.success){
                        getRemarkList();
                    }else {
                        alert("删除失败！")
                    }
                }
            })
        }
    }
    function getActivity(){
        $.ajax({
            url:"workbench/activity/getDetail.do",
            data:{
                "id":"${param.id}"
            },
            dataType:"json",
            type:"get",
            success:function (data) {
                $("#titleName").html("市场活动-" + data.name);
                $("#titleDate").html("   " + data.startDate + "~" + data.endDate);
                $("#search-owner").html(data.owner);
                $("#search-name").html(data.name);
                $("#search-startDate").html(data.startDate);
                $("#search-endDate").html(data.endDate);
                $("#search-cost").html(data.cost);
                $("#search-createBy").html(data.createBy);
                $("#search-createTime").html("   " + data.createTime);
                $("#search-editBy").html(data.editBy);
                $("#search-editTime").html(data.editTime);
                $("#search-description").html(data.description);
            }
        });
    }
    function editRemark(remarkId) {
	    //$("#editRemarkModal").modal("show");
	    $.ajax({
            url:"workbench/activity/editRemark.do",
            data:{
                "id":remarkId
            },
            dataType:"json",
            type:"get",
            success:function (data) {
                $("#noteContent").val(data.noteContent);
                $("#editRemark-id").val(data.id);
                $("#editRemarkModal").modal("show");
            }
        })

    }
</script>


</head>
<body>

	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel1">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <input type="hidden" id="editRemark-id">
                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">
                        <input type="hidden" id="edit-id">

                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">

                                </select>
                            </div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startTime" readonly>
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endTime" readonly>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description"></textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3><span id="titleName"></span><small id="titleDate"></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="search-owner"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="search-name"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="search-startDate"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="search-endDate"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="search-cost"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="search-createBy"></b><small style="font-size: 10px; color: gray;" id="search-createTime">&nbsp;&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
            <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="search-editBy"></b><span>&nbsp;&nbsp;</span><small style="font-size: 10px; color: gray;" id="search-editTime"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="search-description">

				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>