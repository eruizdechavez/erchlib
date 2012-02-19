/*
 * Copyright (c) 2009 Erick Ruiz de Chavez <erickrdch@gmail.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of copyright holders nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL COPYRIGHT HOLDERS OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package com.erickruizdechavez.utils
{
	import flash.external.ExternalInterface;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;

	public class QueryString
	{
		public static function get queryString():String
		{
			if (!ExternalInterface.available)
			{
				Alert.show("JavaScript diabled");
				return "";
			}
			return ExternalInterface.call(
				"window.location.search.substring", 1);
		}

		public static function get fullUrl():String
		{
			if (!ExternalInterface.available)
			{
				Alert.show("JavaScript diabled");
				return "";
			}
			
			var protocol:String = ExternalInterface.call(
				"window.location.protocol.toString");
			var host:String = ExternalInterface.call(
				"window.location.host.toString");
			var pathname:String = ExternalInterface.call(
				"window.location.pathname.substring", 1);

			protocol = protocol == null ? "" : protocol;
			host = host == null ? "" : host;
			pathname = pathname == null ? "" : pathname;

			var url:String = String(protocol + host + pathname).length > 0 
				? protocol + "//" + host + "/" + pathname 
				: "";

			return url;
		}


		public static function get url():String
		{
			if (!ExternalInterface.available)
			{
				Alert.show("JavaScript diabled");
				return "";
			}
			
			var protocol:String = ExternalInterface.call(
				"window.location.protocol.toString");
			var host:String = ExternalInterface.call(
				"window.location.host.toString");
			var port:String = ExternalInterface.call(
				"window.location.port.toString");
			var pathname:String = ExternalInterface.call
				("window.location.pathname.substring", 1);

			protocol = protocol == null ? "" : protocol;
			host = host == null ? "" : host;
			port = port == null || port == "80" ? "" : (":" + port);
			pathname = pathname == null ? "" : pathname;

			var tmpPath:Array = pathname.split("/");
			tmpPath.pop();
			pathname = tmpPath.join("/");

			var url:String = String(protocol + host + pathname).length > 0 
				? protocol + "//" + host + port + "/" + pathname + "/" 
				: "";

			return url;
		}
		
		public static function getHost(url:String = ""):String
		{
			var host:String = "";
			
			if (url == "")
			{
				if (!ExternalInterface.available)
				{
					Alert.show("JavaScript diabled");
					return "";
				}
				
				host = ExternalInterface.call("window.location.host.toString");
				host = host == null ? "" : host;
			}
			else
			{
				host = url;
			}
			
			host = host.replace("http://", "");
			host = host.replace("https://", "");

			var urlArray:ArrayCollection = new ArrayCollection(host.split("/"));

			host = String(urlArray.getItemAt(0));

			return host;
		}

		public static function get params():Object
		{
			var qs:String = queryString ? queryString : "";
			var query:Array = qs.split("&");
			var params:Object = {};

			for (var i:uint = 0; i < query.length; i++)
			{
				params[query[i].split("=")[0]] = query[i].split("=").length > 1 
					? query[i].split("=")[1] 
					: null;
			}
			return params;
		}
	}
}
