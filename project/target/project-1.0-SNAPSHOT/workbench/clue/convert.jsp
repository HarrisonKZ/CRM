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


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		getPage();

		$("#convertBtn").click(function () {
			let flag;
			if ($("#isCreateTransaction").prop("checked")){
				flag = "1";
			}else {
				flag = "0";
			}
			$.ajax({
				url:"workbench/clue/convert.do",
				data:{
					"clueId":"${param.id}",
					"flag":flag,
					"money":$("#amountOfMoney").val(),
					"name":$("#tradeName").val(),
					"expectedDate":$("#expectedClosingDate").val(),
					"stage":$("#stage").val(),
					"activityId":$("#activityId").val()
				},
				dataType: "json",
				type: "get",
				success:function (data) {
					if (data.success){
						window.location.href="workbench/clue/index.jsp";
						return false;
					}
				}
			});

		});

		$("#getActInput").keydown(function (event) {
			if (event.keyCode === 13){
				$.ajax({
					url:"workbench/clue/getAllActivityByName.do",
					data:{
						"name":$("#getActInput").val()
					},
					dataType: "json",
					type: "get",
					success:function (data) {
						let html = "";

						$.each(data,function (i,n) {
							html += '<tr>';
							html += '<td><input type="radio" value="'+ n.id +'" name="activity"/></td>';
							html += '<td id="'+ n.id +'">'+ n.name +'</td>';
							html += '<td>'+ n.startDate +'</td>';
							html += '<td>'+ n.endDate +'</td>';
							html += '<td>'+ n.owner +'</td>';
							html += '</tr>';
						});
						$("#actTbody").html(html);

					}
				});
				return false;
			}

		});

		$("#actBtn").click(function () {
			const $act = $("input[name=activity]:checked");
			const id = $act.val();
			$("#activity").val($("#"+id).html());
			$("#activityId").val(id);
			$("#searchActivityModal").modal("hide");
		})
	});

	function getPage() {
		$.ajax({
			url:"workbench/clue/getDetail.do",
			data:{
				"id":"${param.id}"
			},
			dataType:"json",
			type:"get",
			success:function (data) {
				$("#create-customer").html("新建客户：" + data.company);
				$("#create-contact").html("新建联系人：" + data.fullname + data.appellation);
				$("#create-owner").html(data.owner);
				$("#stage").html("<option></option>");
				let dicMap = JSON.parse('${applicationScope.dicMap}');
				$.each(dicMap.stageList,function (i,n) {
					$("#stage").append("<option value='"+ n.value +"'>" + n.text + "</option>");
				})
			}
		})
	}
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="getActInput" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="actTbody">
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="actBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>李四先生-动力节点</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">

	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">

	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="addTranForm">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="动力节点-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">

		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a data-toggle="modal" data-target="#searchActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
			  <input type="hidden" id="activityId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b id="create-owner"></b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" id="convertBtn" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>