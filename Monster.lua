--
-- Author: mingzi
-- Date: 2015-11-17 10:32:10
--
local Monster = class("Monster", function()
	return display.newSprite()
end)

function Monster:ctor()
	self:init()
	self:setMonster()
	self:addHP()

end

function Monster:doEvent( event )
	if self.fsmMonster:canDoEvent(event) then 
		self.fsmMonster:doEvent(event)
	end
end

function Monster:addHP( )
	local HPbg = display.newSprite("xue_fore.png")
	-- HPbg:setPosition(cc.p(self:getPositionX()-150,self:getPositionY()+200))
	-- self:addChild(HPbg,1)
	self.HpBar = cc.ProgressTimer:create(HPbg)
	self.HpBar:setType(cc.PROGRESS_TIMER_TYPE_BAR) 
	-- self.HpBar:setPosition(cc.p(self:getPositionX()-550,self:getPositionY()+500)) 
    self.HpBar:setMidpoint(cc.p(0,0.5))             
    self.HpBar:setBarChangeRate(cc.p(1,0))          
    self.HpBar:setPercentage(100)                 
    self.HpBar:setPosition(cc.p(self:getPositionX()+150,self:getPositionY()+180))
    self:addChild(self.HpBar,1)
	
end

function Monster:init( )
	print("我是怪物")
	self:addMonsterStateMachine()
end

-- 怪物资源加入缓冲
function Monster:setMonster()
	png="zhubajie.png"
	plist = "zhubajie.plist"
	display.addSpriteFrames(plist,png)

	local png5="zhubajieskill.png"
	local plist5="zhubajieskill.plist"
	display.addSpriteFrames(plist5, png5)

	local pngdead="zhubajiedead.png"
	local plistdead="zhubajiedead.plist"
	display.addSpriteFrames(plistdead, pngdead)
end

function Monster:addMonsterStateMachine()
	png="zhubajie.png"
	plist = "zhubajie.plist"
	display.addSpriteFrames(plist,png)
	self.fsmMonster ={}
	cc.GameObject.extend(self.fsmMonster):addComponent("components.behavior.StateMachine"):exportMethods()
	self.fsmMonster:setupState({

		initial ="idel",
		events = {
			{name ="idelEvents",from ={"attack","walk"},to ="idel"},
			{name ="walkEvents", from ={"idel"},to ="walk"},
			{name ="deadEvents", from ={"idel","attack","walk","hurt"}, to ="dead"},
			{name ="hurtEvents",from ={"idel","attack","walk"},to ="hurt"},
			{name ="attackEvents",from ={"idel","walk"},to ="attack"},
			},
		callbacks={

				onenteridel = function ()
					print("我处于正常状态")
					-- if ModifyData.getX() ==1 then
					self:stopAllActions()
					print("站立状态")
					self:idel()
					-- end
				end,
				onenterwalk = function ()
					print("行走状态")
					-- if ModifyData.getX() ==1 then
					self:stopAllActions()
					self:walk()
					-- end
				end,
				onenterdead = function ()
					print("我死亡正常状态")
					-- if ModifyData.getX() ==1 then
					self:stopAllActions()
					self:dead()
					-- end
				end,
				onenterhurt = function ()
					print("我处于受伤状态")
					-- if ModifyData.getX() ==1 then
					self:stopAllActions()
					print("站立状态")
					self:hurt()
					-- end
				end,
				onenterattack = function ()
					print("我处于攻击状态")
					-- if ModifyData.getX() ==1 then
					self:stopAllActions()
					self:attack()
					-- end
				end,

			},

		})

end

function Monster:idel()
	print("我处于正常状态--相应")
	local idelFrames = display.newFrames("zhubajiestay_%.i.png",1,4)	
	local animation = display.newAnimation(idelFrames,1/4)
	self:playAnimationForever(animation)

end

function Monster:walk()
	print("我处于行走状态--相应")
	local walkFrames = display.newFrames("2RUN00%.2i.png",1,18)	
	local animation = display.newAnimation(walkFrames,1/18)
	self:playAnimationForever(animation)
	
end
function Monster:dead()
	-- self:removeFromParent()
	print("我处于死亡状态--相应")
	
end
function Monster:hurt()
	print("我处于受伤状态--相应")
	local walkFrames = display.newFrames("2BEATTACKFALL00%.2i.png",4,20)	
	local animation = display.newAnimation(walkFrames,1/20)
	-- self:playAnimationForever(animation)
	local call=cc.CallFunc:create(function()
		-- self:removeFromParent()
		self.HpBar:setPercentage(30)
		self:doEvent("idelEvents")
		print("11111111111111111111111111111")
	end)
	local seq = cc.Sequence:create(self:playAnimationOnce(animation),call)
	self:runAction(seq)
	
end
function Monster:attack()
	print("我处于攻击状态--相应")
	local attackFrames = display.newFrames("2EFFECT400%.2i.png",1,44)	
	local animation = display.newAnimation(attackFrames,1/30)
	-- self:playAnimationForever(animation)
	local call=cc.CallFunc:create(function()
		-- self:removeFromParent()
		self:doEvent("idelEvents")
		print("11111111111111111111111111111")
	end)
	local seq = cc.Sequence:create(self:playAnimationOnce(animation),call)
	self:runAction(seq)
	
end


return Monster