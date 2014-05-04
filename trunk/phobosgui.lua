--[[

	PHOBOS GUI - 1 RELEASE
	BY RESTART - 2014
	https://github.com/FreshRestart/phobosgui

]]--

Gui = {}
Gui.__index = Gui

local GuiElements = {}

Gui.DEBUG = false
Gui.FOCUSED = false

Gui.EnableDebugConsole = false
Gui.DebugConsoleSize = 5
Gui.DebugConsole = {}

-- [ELEMENTS] --

function Gui.label( _text, _size, _x, _y, _w, _align, _color, _bckgcolor, _disabled, _visible )
	local obj = {}
	
	obj.id = #GuiElements + 1
	obj.type = "label"
	obj.text = _text or "label" .. obj.id
	obj.text_size = _size or 12
	obj.font = love.graphics.newFont( _size )
	obj.x = _x or 0
	obj.y = _y or 0
	obj.width = _w or 100
	obj.align = _align or "left"
	obj.color = _color or {255, 255, 255, 255}
	obj.backgroundcolor = _bckgcolor or {255, 255, 255, 0}
	obj.disabled = false
	obj.visible = true
	
	if ( _disabled ~= nil ) then
		obj.disabled = _diabled
	end
	
	if ( _visible ~= nil ) then
		obj.visible = _visible
	end
	
	obj.e_click = function( btn ) end
	obj.e_draw = function() end
	
	if ( Gui.DEBUG ) then
		print( "[PhobosGUI]: label id: " .. obj.id .. ", added" )
	end

	table.insert( GuiElements, obj )
	setmetatable( obj, Gui )
	
	return obj
end

function Gui.button( _text, _x, _y, _size, _color, _bckgcolor, _twoColors, _borderColor, _disabled, _visible )
	local obj = {}
	
	obj.id = #GuiElements + 1
	obj.type = "button"
	obj.text = _text or "button" .. obj.id
	obj.text_size = _size or 12
	obj.x = _x or 0
	obj.y = _y or 0
	obj.width = _size or 100
	obj.text_size = 12
	obj.font = love.graphics.newFont( obj.text_size )
	obj.height = (_size / 4) or 25
	obj.color = _color or {255, 255, 255, 255}
	obj.backgroundcolor = _bckgcolor or {255, 255, 255, 0}
	obj.backgroundcolor_2 = Gui.LowColor( obj.backgroundcolor )
	obj.borderColor = _borderColor or {255,255,255,255}
	obj.twoColors = true
	obj.disabled = false
	obj.visible = true
	
	if ( _disabled ~= nil ) then
		obj.disabled = _diabled
	end
	
	if ( _visible ~= nil ) then
		obj.visible = _visible
	end
	
	if ( _twoColors ~= nil ) then
		obj.twoColors = _twoColors
	end
	
	obj.e_click = function( btn ) end
	
	if ( Gui.DEBUG ) then
		print( "[PhobosGUI]: button id: " .. obj.id .. ", added" )
	end
	
	table.insert( GuiElements, obj )
	setmetatable( obj, Gui )
	
	return obj
end

-- [END OF ELEMENTS] --



-- [ELEMENTS FUNCTIONS] --

function Gui:SetPos( _x, _y )
	self.x = _x
	self.y = _y
end

function Gui:GetPos()
	return self.x, self.y
end

function Gui:GetX()
	return self.x
end

function Gui:GetY()
	return self.y
end


function Gui:SetWidth( _w, _notSafe )
	if ( self.type == "label" ) then
		self.width = _w
	end
	
	if ( self.type == "button" ) then
		self.width = _w
	end
end

function Gui:GetWidth()
	return self.width
end

function Gui:SetColor( _color )
	self.color = _color
end

function Gui:GetColor()
	return self.color
end

function Gui:Disable( _disable )
	self.disabled = _disable
end

function Gui:IsDisabled()
	return self.disabled
end

function Gui:SetVisible( _visible )
	self.visible = _visible
end

function Gui:IsVisible()
	return self.visible
end

function Gui:SetBackgroundColor( _color )
	self.backgroundcolor = _color
end

function Gui.GetBackgroundColor()
	return self.backgroundcolor
end

function Gui:SetEvent( _click )
	if ( type(_click) ~= "function" ) then
		assert( false, "Click event type: " .. type(_click) .. ", should be function" )
	end
	
	self.e_click = _click
end

function Gui:Remove()	
	table.remove( GuiElements, self.id )
	
	if ( Gui.DEBUG ) then
		print( "[PhobosGUI]: button id: " .. self.id .. ", removed" )
	end
end

-- [END OF ELEMENTS FUNCTIONS] --



-- [EVENTS] --

function Gui.load( _debug, _enableConsole, _consoleSize )
	Gui.DEBUG = _debug
	Gui.EnableDebugConsole = _enableConsole
	Gui.DebugConsoleSize = _consoleSize or 5
	
	print( "[PhobosGUI]: loaded, debug = " .. tostring(_debug) )
	
	if ( _debug ) then
		Gui.DebugConsoleAdd( "loaded, debug = " .. tostring(_debug) )
	end
end

function Gui.update( dt )
	if ( Gui.DEBUG ) then
		Gui.FOCUSED = love.window.hasFocus()
	end
end

function Gui.draw()
	r, g, b, a = love.graphics.getColor()
	font = love.graphics.getFont()
	
	for k, v in ipairs( GuiElements ) do
		if ( v.visible ) then
			if ( v.type == "label" ) then
				love.graphics.setFont( v.font )
				love.graphics.setColor( v.backgroundcolor )
					love.graphics.rectangle( "fill", v.x - 4, v.y - 4, v.width + 10, v.text_size + 10 )
				love.graphics.setColor( v.color )
					love.graphics.printf( v.text, v.x, v.y, v.width, v.align, 0, 1, 1 )
			end
			
			if ( v.type == "button" ) then
				love.graphics.setColor( v.backgroundcolor )
					love.graphics.rectangle( "fill", v.x, v.y, v.width, v.height )
					
				if ( v.twoColors ) then
					love.graphics.setColor( v.backgroundcolor_2 )	
					love.graphics.rectangle( "fill", v.x, v.y + (v.height / 2), v.width, v.height / 2 )
				end
				
				love.graphics.setColor( v.borderColor )
					love.graphics.rectangle( "line", v.x, v.y, v.width, v.height )
				love.graphics.setColor( v.color )
					love.graphics.printf( v.text, v.x, v.y + (v.height / 2) - (v.text_size / 2), v.width, "center", 0, 1, 1 )
			end
		end
	end
	
	love.graphics.setFont( font )
	
	if ( Gui.DEBUG ) then
		love.graphics.setColor( {255,255,255,125} )
		
		love.graphics.print( "FPS: " .. tostring( love.timer.getFPS() ), 10, 10 )
		love.graphics.print( "Focused: " .. tostring(Gui.FOCUSED), 10, 22 )
		
		if ( Gui.EnableDebugConsole ) then
			for i = 1, Gui.DebugConsoleSize do
				local cur = (#Gui.DebugConsole + 1) - i
				
				if ( Gui.DebugConsole[cur] ~= nil ) then
					love.graphics.print( "[" .. cur .. "]: " .. Gui.DebugConsole[cur], 10, 34 + ( 12 * i ) )
				end
			end
		end
	end
	
	love.graphics.setColor( r, g, b, a )
end

function Gui.mousepressed( x, y, btn )
	for k, v in ipairs( GuiElements ) do
		if ( v.disabled == false ) then
			if ( v.type == "label" ) then
				if ( Gui.IsPressedInBox(x, y, v.x - 4, v.y - 4, v.width + 10, v.text_size + 10) ) then
					pcall( v.e_click, btn )
					
					if ( Gui.DEBUG ) then
						print( "[PhobosGUI]: " .. v.type .. " id: " .. v.id .. ", mouspressed" )
						Gui.DebugConsoleAdd( v.type .. " id: " .. v.id .. ", mouspressed" )
					end
				end
			end
			
			if ( v.type == "button" ) then
				if ( Gui.IsPressedInBox(x, y, v.x, v.y, v.width, v.height) ) then
					pcall( v.e_click, btn )
					
					if ( Gui.DEBUG ) then
						print( "[PhobosGUI]: " .. v.type .. " id: " .. v.id .. ", mouspressed" )
						Gui.DebugConsoleAdd( v.type .. " id: " .. v.id .. ", mouspressed" )
					end
				end
			end
		end
	end
end

-- [END OF EVENTS] --



-- [UTIL FUNCTION] --

function Gui.IsPressedInBox( _px, _py, _x, _y, _w, _h )
	if ( (_px > _x) and (_px < (_x + _w)) and (_py > _y) and (_py < (_y + _h)) ) then
		return true
	else
		return false
	end
end

function Gui.DebugConsoleAdd( text )
	table.insert( Gui.DebugConsole, text )
end

function Gui.LowColor( color )
	new_r = color[1] - 20
	new_g = color[2] - 20
	new_b = color[3] - 20
	
	if ( (new_r > 0) and (new_g > 0) and (new_b > 0) ) then
		return {new_r, new_g, new_b, color[4]}
	else
		return color
	end
end

-- [END OF UTIL FUNCTION] --