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
* 
* 
* Thanks to Luis Parga for giving me the idea of adding date information.
* Thanks to Osvaldo Mercado for requesting a follow up.
* 
* Thanks to "Joony" (http://stackoverflow.com/users/448287/joony) 
* for his function to get the SWF Published date:
* http://stackoverflow.com/questions/2656827/can-actionscript-tell-when-a-swf-was-published
* 
*/
package com.erickruizdechavez.utils
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.managers.SystemManager;
	import mx.preloaders.Preloader;
	import mx.rpc.CallResponder;

	public class DateVersionMenu extends VersionMenu
	{
		public function DateVersionMenu()
		{
			super();
		}
		
		private var _prefix:String = "";
		
		public function get prefix():String
		{
			return _prefix;
		}
		
		public function set prefix(value:String):void
		{
			_prefix = value;
		}
		
		// 0 Year
		// 1 Month
		// 2 Day
		// 3 Hour
		// 4 Minute
		// 5 Second
		// 6 Millisecond
		private var _detail:int = 6;

		public function get detail():int
		{
			return _detail;
		}

		public function set detail(value:int):void
		{
			_detail = value;
		}
		
		private function _intToString(int:int):String
		{
			return (int < 10 ? "0" : "") + int.toString();
		}
		
		override protected function addedToStageHandler(event:Event):void
		{
			var date:Date = getCompilationDate();
			var ver:String = "";
			
			switch(detail)
			{
				case 6:
					ver = "." + _intToString(date.getUTCMilliseconds());
				case 5:
					ver = _intToString(date.getUTCSeconds()) + ver;
				case 4:
					ver = _intToString(date.getUTCMinutes()) + ver;
				case 3:
					ver = (ver != "" ? "." : "") + _intToString(date.getUTCHours()) + ver;
				case 2:
					ver = _intToString(date.getUTCDate()) + ver;
				case 1:
					ver = (ver != "" ? "." : "") + _intToString(date.getUTCMonth() + 1) + ver;
				case 0:
					ver = _intToString(date.getUTCFullYear() - 2000) + ver;
			}
			
			label = prefix + ver;
			super.addedToStageHandler(event);
		}
		
		private function getCompilationDate():Date
		{
			var swf:ByteArray = SystemManager.getSWFRoot(this).loaderInfo.bytes;
			swf.endian = Endian.LITTLE_ENDIAN;
			
			// Signature + Version + FileLength + FrameSize + FrameRate + FrameCount
			swf.position = 3 + 1 + 4 + (Math.ceil(((swf[8] >> 3) * 4 - 3) / 8) + 1) + 2 + 2;
			while(swf.position != swf.length)
			{
				var tagHeader:uint = swf.readUnsignedShort();
				if(tagHeader >> 6 == 41)
				{
					// ProductID + Edition + MajorVersion + MinorVersion + BuildLow + BuildHigh
					swf.position += 4 + 4 + 1 + 1 + 4 + 4;
					var milli:Number = swf.readUnsignedInt();
					var date:Date = new Date();
					date.setTime(milli + swf.readUnsignedInt() * 4294967296);
					return date; // Sun Oct 31 02:56:28 GMT+0100 2010
				}
				else
				{
					swf.position += (tagHeader & 63) != 63 ? (tagHeader & 63) : swf.readUnsignedInt() + 4;
				}
			}
			throw new Error("No ProductInfo tag exists");
		}
	}
}