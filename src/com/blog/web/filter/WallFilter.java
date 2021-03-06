package com.blog.web.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import com.blog.web.base.cache.CacheFinal;
import com.blog.web.base.cache.CacheTimerHandler;
import com.blog.web.base.wrapper.XssHttpServletRequestWrapper;
import com.blog.web.util.RequestUtil;
import com.blog.web.util.StringUtils;

/**
 *
 * 拦截防止XSS跨站脚本攻击以及高频请求
 *
 * @author WebSOS
 * @time 2015-06-09
 */
public class WallFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	public void destroy() {
	}

	/**
	 * 過濾
	 */
	public void doFilter(ServletRequest req, ServletResponse resp,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		if(doWall(request)){
			//过滤Xss跨站脚本攻击
			chain.doFilter(new XssHttpServletRequestWrapper(request), resp);
		}
	}
	//拦截CC攻击
	private boolean doWall(HttpServletRequest request){
		String ip=RequestUtil.getIpAddr(request);
		String userAgent=request.getHeader("User-Agent");
		System.out.println("{[收到请求]请求地址:"+request.getRequestURI()+",IP地址:"+ip+",User-Agent:"+userAgent+"}");
		String key=CacheFinal.WALL_IP_CACHE+ip.replace(".", "_");
		Integer num=(Integer) CacheTimerHandler.getCache(key);
		if(StringUtils.isNullOrEmpty(num)){
			num=0;
		}
		if(num>600){
			CacheTimerHandler.addCache(key, 600,60*60*24);
			System.out.println("IP:"+ip+"在系统黑名单，已禁止访问");
			//销毁session
			request.getSession().invalidate();
			try {
				Runtime.getRuntime().exec("iptables -I INPUT -s "+ip+" -j DROP");
			} catch (Exception e) {
			}
			return false;
		}
		CacheTimerHandler.addCache(key, num+1,60);
		return true;
	}
}