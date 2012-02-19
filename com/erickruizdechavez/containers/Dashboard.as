/*
 * Copyright (c) 2010 Erick Ruiz de Chavez <erickrdch@gmail.com>
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
package com.erickruizdechavez.containers
{
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.events.DynamicEvent;

	public class Dashboard extends Canvas
	{
		public function Dashboard()
		{
			super();
		}
		
		private var _maxPerRow:int = 3;

		public function get maxPerRow():int
		{
			return _maxPerRow;
		}

		public function set maxPerRow(value:int):void
		{
			if (value < 1 || _maxPerRow == value)
				return;
				
			_maxPerRow = value;
			invalidateDisplayList();
		}
		
		private var _horizontalGap:int = 5;

		public function get horizontalGap():int
		{
			return _horizontalGap;
		}

		public function set horizontalGap(value:int):void
		{
			if (_horizontalGap == value)
				return;
			
			_horizontalGap = value;
			invalidateDisplayList();
			
		}
		
		private var _verticalGap:int = 5;

		public function get verticalGap():int
		{
			return _verticalGap;
		}

		public function set verticalGap(value:int):void
		{
			if (_verticalGap == value)
				return;
			
			_verticalGap = value;
			invalidateDisplayList();
		}
		
		private var _paddingTop:int = 5;

		public function get paddingTop():int
		{
			return _paddingTop;
		}

		public function set paddingTop(value:int):void
		{
			if (_paddingTop == value)
				return;
			
			_paddingTop = value;
			invalidateDisplayList();
		}

		private var _paddingBottom:int = 5;

		public function get paddingBottom():int
		{
			return _paddingBottom;
		}

		public function set paddingBottom(value:int):void
		{
			if (_paddingBottom == value)
				return;
			
			_paddingBottom = value;
			invalidateDisplayList();
		}

		private var _paddingLeft:int = 5;

		public function get paddingLeft():int
		{
			return _paddingLeft;
		}

		public function set paddingLeft(value:int):void
		{
			if (_paddingLeft == value)
				return;
			
			_paddingLeft = value;
			invalidateDisplayList();
		}

		private var _paddingRight:int = 5;

		public function get paddingRight():int
		{
			return _paddingRight;
		}

		public function set paddingRight(value:int):void
		{
			if (_paddingRight == value)
				return;
			
			_paddingRight = value;
			invalidateDisplayList();
		}
		
		private var _showAll:Boolean = true;
		
		public function get showAll():Boolean
		{
			return _showAll;
		}
		
		public function set showAll(value:Boolean):void
		{
			_showAll = value;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var heightDivisor:int = _showAll ? Math.ceil(numChildren / _maxPerRow) : _maxPerRow;
			var scrollBarWidth:int = 0
			if (verticalScrollBar)
				scrollBarWidth = ((numChildren > _maxPerRow * 2) && !_showAll) ? verticalScrollBar.width : 0;

			var elementWidth:int = (width - scrollBarWidth - _paddingLeft - _paddingRight - _horizontalGap * (Math.min(_maxPerRow, numChildren) - 1)) / Math.min(_maxPerRow, numChildren);
			var elementHeight:int = (height - _paddingTop - _paddingBottom - _verticalGap * (heightDivisor - 1)) / heightDivisor;
			
			var currentCol:int = 0;
			var currentRow:int = 0;
			
			for (var i:int = 0; i < numChildren; i++)
			{
				getChildAt(i).width = elementWidth;
				getChildAt(i).height = elementHeight;
				
				getChildAt(i).x = _paddingLeft + (currentCol * elementWidth) + (currentCol * _horizontalGap); 
				getChildAt(i).y = _paddingTop + (currentRow * elementHeight) + (currentRow * _verticalGap);
				
				currentCol++;
				
				if (currentCol >= _maxPerRow)
				{
					currentCol = 0;
					currentRow ++;
				}
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}