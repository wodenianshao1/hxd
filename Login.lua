--
-- Author: mingzi
-- Date: 2015-11-12 13:39:55
--
local Login = class("Login", function(  )
	return display.newScene()
end)

function Login:ctor()
	self:init()
end

function Login:init(  )
	local scene = cc.uiloader:load("LoginScene.csb"):addTo(self)
	local btn_cancel = scene:getChildByName("btn_cancel");
	 btn_cancel:addTouchEventListener(function(psender,event)
    	local scene = require("app.scenes.IndexScene").new()
    	-- local turn =cc.TransitionFlipX:create(1, scene)
    	local turn = cc.TransitionProgressHorizontal:create(1, scene)
    	cc.Director:getInstance():replaceScene(turn)
    end)
end

return Login