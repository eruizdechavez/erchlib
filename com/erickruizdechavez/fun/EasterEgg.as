/*
 * Copyright (c) 2009, Erick Ruiz de Chavez <erickrdch@gmail.com> 
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
package com.erickruizdechavez.fun
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.core.Application;
	
	public class EasterEgg
	{
		private var _secretWord:String;
		private var _lastMatch:int;
		private var _easterHandler:Function;
		private var _catchAlt:Boolean;

		public function get catchAlt():Boolean
		{
			return _catchAlt;
		}

		public function set catchAlt(value:Boolean):void
		{
			_catchAlt = value;
		}

		private var _catchShift:Boolean;

		public function get catchShift():Boolean
		{
			return _catchShift;
		}

		public function set catchShift(value:Boolean):void
		{
			_catchShift = value;
		}

		private var _catchCtrl:Boolean;

		public function get catchCtrl():Boolean
		{
			return _catchCtrl;
		}

		public function set catchCtrl(value:Boolean):void
		{
			_catchCtrl = value;
		}

		
		public function EasterEgg()
		{
			_lastMatch = -1;
			Application.application
				.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		public function get secretWord():String
		{
			return _secretWord;
		}
		
		public function set secretWord(value:String):void
		{
			_secretWord = value;
		}

		public function get easterHandler():Function
		{
			return _easterHandler;
		}
		
		public function set easterHandler(value:Function):void
		{
			_easterHandler = value;
		}

		protected function addedToStageHandler(event:Event):void
		{
			Application.application.stage
				.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}
		
		protected function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if (!_catchAlt && !_catchCtrl && !_catchShift)
				return;
			
			if (secretWord == null || secretWord.length <= 0)
				return;
			
			if (XNOR(_catchAlt, event.altKey) && 
				XNOR(_catchShift, event.shiftKey) &&  
				XNOR(_catchCtrl, event.ctrlKey))
			{
				if (_lastMatch < 0)
					_lastMatch = 0;
				
				var char:String = secretWord.charAt(_lastMatch);
				char = char.toUpperCase();
				
				var pressedChar:String = String.fromCharCode(event.charCode);
				pressedChar = pressedChar.toUpperCase();
				
				if (char == pressedChar)
					_lastMatch ++;
				else
					_lastMatch = -1;
				
				if (_lastMatch == secretWord.length && easterHandler != null)
				{
					_lastMatch = -1;
					easterHandler();
				}
			}
		}
		
		protected function XNOR(a:Boolean, b:Boolean):Boolean
		{
			if (a && b)
				return true;
			else if (!a && !b)
				return true;
			
			return false;
		}
	}
}