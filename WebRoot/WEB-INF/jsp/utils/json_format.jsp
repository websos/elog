<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<jsp:include page="header.jsp" />
</head>
<body>
	<jsp:include page="js.jsp" />
	<div class="am-g">
		<div class="am-u-md-12">
			<div class="am-panel am-panel-default">
				<div class="am-panel-hd">${utils.title }</div>
				<div class="am-panel-bd">
					<div class="am-form">
						<fieldset>
							<div class="am-form-group am-form-success">
								<textarea id="currId" class="am-field-valid"
									style="height:13.5rem"></textarea>
							</div>
							<p>
								<button type="button" onclick="doFormat()"
									class="am-btn am-btn-danger am-round">
									<i class="am-icon-spinner am-icon-spin"></i> 格式化效验
								</button>
							</p>
							<div class="am-form-group">
								<textarea id="targeId" style="height:17rem"></textarea>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<jsp:include page="../comm/foot.jsp" />
		</div>
	</div>
</body>
<script type='text/javascript'>
function doFormat(){
	var json=format($("#currId").val());
	$('#targeId').val(json);
}
function format(txt,compress/*是否为压缩模式*/){/* 格式化JSON源码(对象转换为JSON文本) */  
    var indentChar = '    ';   
    if(/^\s*$/.test(txt)){   
        alert('数据为空,无法格式化! ');   
        return;   
    }   
    try{var data=eval('('+txt+')');}   
    catch(e){   
        alert('数据源语法错误,格式化失败! 错误信息: '+e.description,'err');   
        return;   
    };   
    var draw=[],last=false,This=this,line=compress?'':'\n',nodeCount=0,maxDepth=0;   
       
    var notify=function(name,value,isLast,indent/*缩进*/,formObj){   
        nodeCount++;/*节点计数*/  
        for (var i=0,tab='';i<indent;i++ )tab+=indentChar;/* 缩进HTML */  
        tab=compress?'':tab;/*压缩模式忽略缩进*/  
        maxDepth=++indent;/*缩进递增并记录*/  
        if(value&&value.constructor==Array){/*处理数组*/  
            draw.push(tab+(formObj?('"'+name+'":'):'')+'['+line);/*缩进'[' 然后换行*/  
            for (var i=0;i<value.length;i++)   
                notify(i,value[i],i==value.length-1,indent,false);   
            draw.push(tab+']'+(isLast?line:(','+line)));/*缩进']'换行,若非尾元素则添加逗号*/  
        }else   if(value&&typeof value=='object'){/*处理对象*/  
                draw.push(tab+(formObj?('"'+name+'":'):'')+'{'+line);/*缩进'{' 然后换行*/  
                var len=0,i=0;   
                for(var key in value)len++;   
                for(var key in value)notify(key,value[key],++i==len,indent,true);   
                draw.push(tab+'}'+(isLast?line:(','+line)));/*缩进'}'换行,若非尾元素则添加逗号*/  
            }else{   
                    if(typeof value=='string')value='"'+value+'"';   
                    draw.push(tab+(formObj?('"'+name+'":'):'')+value+(isLast?'':',')+line);   
            };   
    };   
    var isLast=true,indent=0;   
    notify('',data,isLast,indent,false);   
    return draw.join('');   
}  
</script>
</html>
