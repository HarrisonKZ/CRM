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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function () {
		pageList(1,3);
		$("#searchBtn").click(function () {
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startTime").val($.trim($("#search-startTime").val()));
			$("#hidden-endTime").val($.trim($("#search-endTime").val()));
			pageList(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"));
		});
		$("#addBtn").click(function () {
			$("#create-marketActivityOwner").html("");
			$.ajax({
				url:"workbench/activity/getUserList.do",
				dataType:"json",
				type:"get",
				success:function (data) {
					$("#create-marketActivityOwner").append("<option></option>");
					$.each(data,function (i,n) {
						$("#create-marketActivityOwner").append("<option value='" + n.id + "'>" + n.name + "</option>")
					});
					$("#create-marketActivityOwner").val("${sessionScope.user.id}");
					$(".time").datetimepicker({
						minView: "month",
						language:  'zh-CN',
						format: 'yyyy-mm-dd',
						autoclose: true,
						todayBtn: true,
						pickerPosition: "bottom-left"
					});
					$("#createActivityModal").modal("show");
				}
			});
		});

		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/activity/saveActivity.do",
				data:{
					"owner":$.trim($("#create-marketActivityOwner").val()),
					"name":$.trim($("#create-marketActivityName").val()),
					"startDate":$.trim($("#create-startTime").val()),
					"endDate":$.trim($("#create-endTime").val()),
					"cost":$.trim($("#create-cost").val()),
					"description":$.trim($("#create-describe").val())
				},
				dataType: "json",
				type: "post",
				success:function (data) {
					if (data.success){
						alert("保存成功！");
						$("#create-form")[0].reset();
						$("#createActivityModal").modal("hide");
						pageList(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"))
					}else {
						alert("保存失败！")
					}
				}
			})
		});

		$("#checkboxAll").click(function () {
			$("input[name=activityCheckbox]").prop("checked",this.checked);
		});

		$("#activityTbody").on("click",$("input[name=activityCheckbox]"),function () {

			$("#checkboxAll").prop("checked",$("input[name=activityCheckbox]").length===$("input[name=activityCheckbox]:checked").length)
		});

		$("#deleteBtn").click(function () {
			const checkboxed = $("input[name=activityCheckbox]:checked");
			let param = "";
			if (checkboxed.length === 0){
				alert("请先选中要删除的活动")
			}else {
				if (confirm("您确定要删除选中的市场活动嘛？")){
					for(let i = 0;i < checkboxed.length; i++){
						param +="id=" + $(checkboxed[i]).val();
						if (i < checkboxed.length - 1){
							param += "&";
						}
					}
					$.ajax({
						url:"workbench/activity/deleteActivity.do",
						data:param,
						dataType:"json",
						type:"post",
						success:function (data) {
							if (data.success){
								alert("删除成功！");
								pageList(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"));
							}else {
								alert("删除失败！")
							}
						}
					})
				}
			}
		});
		$("#editBtn").click(function () {
			const checkboxed = $("input[name=activityCheckbox]:checked");
			if (checkboxed.length === 0){
				alert("请选中一条您要修改的市场活动记录")
			}
			if (checkboxed.length > 1){
				alert("不能同时修改多条市场活动记录，请选中一条您要修改的市场活动记录")
			}else {
				$.ajax({
					url:"workbench/activity/editActivity.do",
					data:{
						"id":checkboxed.val()
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
			}
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
							alert("修改成功！");
							$("#editActivityModal").modal("hide");
							pageList($("#activityPage").bs_pagination("getOption","currentPage"),$("#activityPage").bs_pagination("getOption","rowsPerPage"));
						}else {
							alert("修改失败！")
						}
					}
				})
			}
		});

		$("#activityTbody").on("mousemove","a[name=toDetail]",function(){
			$("a[name=toDetail]").unbind();
			for (let i = 0;i <$("a[name=toDetail]").length;i++){
				$($("a[name=toDetail]")[i]).click(function () {
					//window.location.href = "workbench/activity/detail.jsp?id=" + $($("a[name=toDetail]")[i]).attr("value");
					/*$.ajax({
						url:"workbench/activity/detail.jsp",
						data:{
							"id":$($("a[name=toDetail]")[i]).attr("value")
						},
						type:"post",
					})*/
					$("#detailInput").val($($("a[name=toDetail]")[i]).attr("value"));
					$("#detailForm").submit();
				})
			}
		});
	});

	function pageList(pageNo,pageSize) {
		$("#checkboxAll").prop("checked",false);
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startTime").val($.trim($("#hidden-startTime").val()));
		$("#search-endTime").val($.trim($("#hidden-endTime").val()));
		$.ajax({
			url:"workbench/activity/getPageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"owner":$.trim($("#search-owner").val()),
				"name":$.trim($("#search-name").val()),
				"startDate":$.trim($("#search-startTime").val()),
				"endDate":$.trim($("#search-endTime").val()),
			},
			dataType:"json",
			type:"get",
			success:function (data) {
				$("#activityTbody").html("");
				$.each(data.activityList,function (i,n) {
					$("#activityTbody").append(
						'<tr class="active">'+
						'<td><input type="checkbox"  name="activityCheckbox" value="' + n.id + '" /></td>'+
						'<td><a style="text-decoration: none; cursor: pointer;" name="toDetail" id="toDetail'+ i +'" value="'+ n.id +'">' + n.name + '</a></td>'+
						'<td>' + n.owner + '</td>'+
						'<td>' + n.startDate + '</td>'+
						'<td>' + n.endDate + '</td>'+
						'</tr>'
					)
				});


				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: data.totalSize%pageSize===0?data.totalSize/pageSize:parseInt(data.totalSize/pageSize)+1, // 总页数
					totalRows: data.totalSize, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});


			}
		})
	}
	
</script>
</head>
<body>
	<form id="detailForm" action="workbench/activity/detail.jsp" method="post">
		<input type="hidden" id="detailInput" name="id">
	</form>
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="create-form" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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
                                <input type="text" class="form-control" id="edit-name" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
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
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startTime">
	<input type="hidden" id="hidden-endTime">
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endTime">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkboxAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityTbody">


					</tbody>
				</table>
			</div>
			
			<div id="activityPage">

			</div>
			
		</div>
		
	</div>
</body>
</html>