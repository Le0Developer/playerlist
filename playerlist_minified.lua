local e="LeoDeveloper"local t="1.2.3"local a=""for Z=1,16 do local ee=math.random(1,16)a=a.. ("0123456789abcdef"):sub(ee,ee)end local o={}local i={}local n={}local s={}local h=gui.Reference("Menu")local r=300 local d=gui.Tab(gui.Reference("Misc"),"playerlist","Player List")local l do local Z=gui.Window("playerlist","Player List",100,100,530,600)Z:SetActive(false)l=Z end local u={x=8,y=8,w=618,h=108}local c=gui.Groupbox(d,"Menu Controller",u.x,u.y,u.w,u.h)local m do local Z=gui.Combobox(c,"controller.mode","Menu Mode","Tab","Window")Z:SetWidth(200)m=Z end local f do local Z=gui.Keybox(c,"controller.openkey","Window Openkey",0)Z:SetWidth(200)Z:SetPosX(210)Z:SetPosY(0)Z:SetDisabled(true)f=Z end local w=nil local y={x=u.x,y=u.y+u.h,w=r,h=0}local p=gui.Groupbox(d,"Select a player",y.x,y.y,y.w,y.h)local v=gui.Listbox(p,tostring(a)..".players",440)local b do local Z=gui.Button(p,"Clear",function()w=nil v:SetOptions()s={}n={}end)Z:SetPosX(188)Z:SetPosY(-42)Z:SetWidth(80)b=Z end local g={x=y.x+y.w+4,y=y.y,w=618-r,h=0}local k=gui.Groupbox(d,"Per Player Settings",g.x,g.y,g.w,g.h)local q q=function(Z)return{set=function(ee,et)Z.settings[ee]=et if#n>0 and n[v:GetValue()+1]==Z.info.uid then return i[ee].set(et)end end,get=function(ee)return Z.settings[ee]end}end local j j=function(Z,ee)local et={}local ea={obj=Z}ea.reapply=function(eo)ea.obj=eo for ei,en in pairs(et)do eo[ei](eo,unpack(en))end end setmetatable(ea,{__index=function(eo,ei)if ei:sub(1,3)=="Set"then return function(eo,...)et[ei]={...}return ea.obj[ei](ea.obj,...)end end return function(eo,...)return ea.obj[ei](ea.obj,...)end end})return ea end plist={gui={Checkbox=function(Z,ee,et)local ea=gui.Checkbox(k,tostring(a)..".settings."..tostring(Z),ee,et)local eo=j(ea)i[Z]={set=function(ei)return ea:SetValue(ei)end,get=function()return ea:GetValue()end,default=et,obj=ea}for ei,en in pairs(s)do en.settings[Z]=et end table.insert(o,{obj=ea,recreate=function()ea=gui.Checkbox(k,tostring(a)..".settings."..tostring(Z),ee,et)eo.reapply(ea)return ea end})return eo end,Slider=function(Z,ee,et,ea,eo,ei)local en=gui.Slider(k,tostring(a)..".settings."..tostring(Z),ee,et,ea,eo,ei or 1)local es=j(en)i[Z]={set=function(eh)return en:SetValue(eh)end,get=function()return en:GetValue()end,default=et,obj=en}for eh,er in pairs(s)do er.settings[Z]=et end table.insert(o,{obj=en,recreate=function()en=gui.Slider(k,tostring(a)..".settings."..tostring(Z),ee,et,ea,eo,ei or 1)es.reapply(en)return en end})return es end,ColorPicker=function(Z,ee,et,ea,eo,ei)local en=gui.ColorPicker(k,tostring(a)..".settings."..tostring(Z),et,ea,eo,ei)local es=j(en)i[Z]={set=function(eh)return en:SetValue(unpack(eh))end,get=function()return{en:GetValue()}end,default={et,ea,eo,ei},obj=en}for eh,er in pairs(s)do er.settings[Z]={et,ea,eo,ei}end table.insert(o,{obj=en,recreate=function()en=gui.ColorPicker(k,tostring(a)..".settings."..tostring(Z),et,ea,eo,ei)es.reapply(en)return en end})return es end,Text=function(Z,ee)local et=gui.Text(k,ee)local ea=j(et)local eo=ee i[Z]={set=function(ei)et:SetText(ei)eo=ei end,get=function()return eo end,default=ee,obj=et}for ei,en in pairs(s)do en.settings[Z]=ee end table.insert(o,{obj=et,recreate=function()et=gui.Text(k,ee)ea.reapply(et)return et end})return ea end,Combobox=function(Z,ee,...)local et=gui.Combobox(k,tostring(a)..".settings."..tostring(Z),ee,...)local ea=j(et)i[Z]={set=function(ei)return et:SetValue(ei)end,get=function()return et:GetValue()end,default=0,obj=et}for ei,en in pairs(s)do en.settings[Z]=0 end local eo={...}table.insert(o,{obj=et,recreate=function()et=gui.Combobox(k,tostring(a)..".settings."..tostring(Z),ee,unpack(eo))ea.reapply(et)return et end})return ea end,Button=function(Z,ee)local et et=function()if#n>0 then ee(n[v:GetValue()+1])else ee()end end local ea=gui.Button(k,Z,et)local eo=j(ea)table.insert(o,{obj=ea,recreate=function()ea=gui.Button(k,Z,et)eo.reapply(ea)return ea end})return eo end,Editbox=function(Z,ee)local et=gui.Editbox(k,Z,ee)local ea=j(et)i[Z]={set=function(eo)return et:SetValue(eo)end,get=function()return et:GetValue()end,default=0,obj=et}for eo,ei in pairs(s)do ei.settings[Z]=0 end table.insert(o,{obj=et,recreate=function()et=gui.Editbox(k,Z,ee)ea.reapply(et)return et end})return ea end,Multibox=function(Z)local ee=gui.Multibox(k,Z)local et=j(ee)table.insert(o,{obj=ee,recreate=function()ee=gui.Multibox(k,Z)et.reapply(ee)return ee end})return et end,Multibox_Checkbox=function(Z,ee,et,ea)local eo=gui.Checkbox(Z.obj,tostring(a)..".settings."..tostring(ee),et,ea)local ei=j(eo)i[ee]={set=function(en)return eo:SetValue(en)end,get=function()return eo:GetValue()end,default=ea,obj=eo}for en,es in pairs(s)do es.settings[ee]=ea end table.insert(o,{obj=eo,recreate=function()eo=gui.Checkbox(Z.obj,tostring(a)..".settings."..tostring(ee),et,ea)ei.reapply(eo)return eo end})return ei end,Multibox_ColorPicker=function(Z,ee,et,ea,eo,ei,en)local es=gui.ColorPicker(Z.obj,ee,ea,eo,ei,en)local eh=j(es)i[ee]={set=function(er)return es:SetValue(unpack(er))end,get=function()return{es:GetValue()}end,default={ea,eo,ei,en},obj=es}for er,ed in pairs(s)do ed.settings[ee]={ea,eo,ei,en}end table.insert(o,{obj=es,recreate=function()es=gui.ColorPicker(Z.obj,tostring(a)..".settings."..tostring(ee),ea,eo,ei,en)eh.reapply(es)return es end})return eh end,Remove=function(Z)Z:Remove()for ee,et in pairs(i)do if et.obj==Z.obj then i[ee]=nil for ea,eo in pairs(s)do eo.settings[ee]=nil end break end end end},GetByUserID=function(Z)if not s[Z]then error("Playerlist: No settings for userid: "..tostring(Z),2)end return q(s[Z])end,GetByIndex=function(Z)local ee=client.GetPlayerInfo(Z)if ee~=nil then if not s[ee["UserID"]]then error("Playerlist: No settings for index: "..tostring(Z),2)end return q(s[ee["UserID"]])end for et,ea in pairs(s)do if ea.info.index==Z then return q(ea)end end end,GetSelected=function()if#n>0 then q(s[n[v:GetValue()+1]])end return nil end,GetSelectedIndex=function()if#n>0 then local Z=s[n[v:GetValue()+1]].info.index end return nil end,GetSelectedUserID=function()if#n>0 then local Z=n[v:GetValue()+1]end return nil end}local x=0 local z=0 local _ _=function(Z)if Z==1 then return"SPECTATOR"elseif Z==2 then return"T"else return"CT"end end callbacks.Register("Draw","playerlist.callbacks.Draw",function()if f:GetValue()==0 and m:GetValue()==1 then l:SetActive(h:IsActive())end if not h:IsActive()and(m:GetValue()==0 or(not l:IsActive()or m:GetValue()~=0))then return end if f:GetValue()~=z and m:GetValue()==1 then z=f:GetValue()l:SetOpenKey(z)end if m:GetValue()~=x then if m:GetValue()==0 then p:Remove()v:Remove()b:Remove()p=gui.Groupbox(d,"Select a player",y.x,y.y,y.w,y.h)v=gui.Listbox(p,tostring(a)..".players",440)do local Z=gui.Button(p,"Clear",function()w=nil v:SetOptions()s={}n={}end)Z:SetPosX(188)Z:SetPosY(-42)Z:SetWidth(80)b=Z end k:Remove()k=gui.Groupbox(d,"Per Player Settings",g.x,g.y,g.w,g.h)for Z=1,#o do o[Z].obj:Remove()o[Z].obj=o[Z].recreate(k)end f:SetDisabled(true)l:SetActive(false)l:SetOpenKey(0)else p:Remove()v:Remove()b:Remove()p=gui.Groupbox(l,"Select a player",8,8,188,584)v=gui.Listbox(p,tostring(a)..".players",494)do local Z=gui.Button(p,"Clear",function()w=nil v:SetOptions()s={}n={}end)Z:SetPosX(84)Z:SetPosY(-42)Z:SetWidth(80)b=Z end k:Remove()k=gui.Groupbox(l,"Per Player Settings",200,8,318,584)for Z=1,#o do o[Z].obj:Remove()o[Z].obj=o[Z].recreate(k)end f:SetDisabled(false)l:SetOpenKey(f:GetValue())end x=m:GetValue()w=nil v:SetOptions(unpack((function()local Z={}local ee=1 for et,ea in ipairs(n)do Z[ee]="[".._(s[ea].info.team).."] "..s[ea].info.nickname ee=ee+1 end return Z end)()))end if#n==0 then for Z=1,#o do local ee=o[Z]ee.obj:SetDisabled(true)end w=nil return elseif w==nil then for Z=1,#o do local ee=o[Z]ee.obj:SetDisabled(false)end end if w~=v:GetValue()then w=v:GetValue()local Z=s[n[v:GetValue()+1]].settings for ee,et in pairs(i)do et.set(Z[ee])end else local Z=s[n[v:GetValue()+1]].settings for ee,et in pairs(i)do Z[ee]=et.get()end end end)local E=nil local T=nil callbacks.Register("CreateMove","playerlist.callbacks.CreateMove",function(Z)if engine.GetMapName()~=E or engine.GetServerIP()~=T then E=engine.GetMapName()T=engine.GetServerIP()w=nil v:SetOptions()s={}n={}end local ee=entities.FindByClass("CCSPlayer")for et=1,#ee do local ea=false repeat local eo=ee[et]if client.GetPlayerInfo(eo:GetIndex())["IsGOTV"]then ea=true break end local ei=client.GetPlayerInfo(eo:GetIndex())["UserID"]if s[ei]==nil then table.insert(n,ei)s[ei]={info={nickname=eo:GetName(),uid=ei,index=eo:GetIndex(),team=eo:GetProp("m_iPendingTeamNum")},settings={}}local en=s[ei].settings for es,eh in pairs(i)do en[es]=eh.default end w=nil v:SetOptions(unpack((function()local es={}local eh=1 for er,ed in ipairs(n)do es[eh]="[".._(s[ed].info.team).."] "..s[ed].info.nickname eh=eh+1 end return es end)()))end if s[ei].info.nickname~=eo:GetName()then s[ei].info.nickname=eo:GetName()v:SetOptions(unpack((function()local en={}local es=1 for eh,er in ipairs(n)do en[es]="[".._(s[er].info.team).."] "..s[er].info.nickname es=es+1 end return en end)()))end if s[ei].info.team~=eo:GetProp("m_iPendingTeamNum")then s[ei].info.team=eo:GetProp("m_iPendingTeamNum")v:SetOptions(unpack((function()local en={}local es=1 for eh,er in ipairs(n)do en[es]="[".._(s[er].info.team).."] "..s[er].info.nickname es=es+1 end return en end)()))end ea=true until true if not ea then break end end end)http.Get("https://raw.githubusercontent.com/Le0Developer/playerlist/master/version",function(Z)if not Z then return end if Z==t then return end local ee=180 local et=gui.Groupbox(d,"Update Available",u.x,u.y+u.h,618,ee)local ea=gui.Text(et,"Current version: "..tostring(t).."\nLatest version: "..tostring(Z))local eo=gui.Checkbox(et,"updater.minified","Download minified version",true)local ei do local en=gui.Button(et,"Update",function()ea:SetText("Updating...")ei:SetDisabled(true)http.Get(((function()if eo:GetValue()then return"https://raw.githubusercontent.com/Le0Developer/playerlist/master/playerlist_minified.lua"else return"https://raw.githubusercontent.com/Le0Developer/playerlist/master/playerlist.lua"end end)()),function(es)if es then ea:SetText("Saving...")do local eh=file.Open(GetScriptName(),"w")eh:Write(es)eh:Close()end return ea:SetText("Updated to version: "..tostring(Z)..".\nReload `"..tostring(GetScriptName()).."` for changes to take effect.")else ea:SetText("Failed.")return ei:SetDisabled(false)end end)end)en:SetWidth(290)ei=en end do local en=gui.Button(et,"Open Changelog in Browser",function()local es=""local eh="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-"do local er={}for ed=1,#eh do er[eh:sub(ed,ed)]=true end eh=er end for er=1,#Z do if eh[Z:sub(er,er)]then es=es..Z:sub(er,er)end end return panorama.RunScript("SteamOverlayAPI.OpenExternalBrowserURL( 'https://github.com/Le0Developer/playerlist/blob/master/changelog.md#version-"..es.."' );")end)en:SetWidth(290)en:SetPosX(300)en:SetPosY(78)end y.y=y.y+ee p:SetPosY(y.y)g.y=g.y+ee if m:GetValue()==0 then return k:SetPosY(g.y)end end)do local Z=plist.gui.Combobox("resolver.type","Resolver","Automatic","On","Off")Z:SetDescription("Choose a resolver for this player.")end callbacks.Register("AimbotTarget","playerlist.extensions.Resolver.AimbotTarget",function(Z)if not Z:GetIndex()then return end local ee=plist.GetByIndex(Z:GetIndex())local et=false if ee.get("resolver.type")==0 then if Z:GetPropVector("m_angEyeAngles").x>=85 then et=true elseif Z:GetPropFloat("m_flPoseParameter",11)>29 then et=true end elseif ee.get("resolver.type")==1 then et=true end if gui.GetValue("rbot.master")then return gui.SetValue("rbot.accuracy.posadj.resolver",et and 1 or 0)else return gui.SetValue("lbot.posadj.resolver",et)end end)local A=nil local O=false callbacks.Register("AimbotTarget","playerlist.extensions.Priority.AimbotTarget",function(Z)if not Z:GetIndex()then return end if A and Z:GetIndex()~=A:GetIndex()then if O then gui.SetValue("rbot.aim.target.lock",false)end A=Z O=false elseif O then return gui.SetValue("rbot.aim.target.fov",180)end end)do local Z=plist.gui.Combobox("targetmode","Targetmode","Normal","Friendly","Priority")Z:SetDescription("Mode for targetting. NOTE: Priority on teammates attack them.")end local I=3 local N={}callbacks.Register("CreateMove","playerlist.extensions.Priority.CreateMove",function(Z)local ee=entities.GetLocalPlayer()local et=entities.FindByClass("CCSPlayer")for ea=1,#et do local eo=false repeat local ei=et[ea]if not ei:IsAlive()then eo=true break end local en=plist.GetByIndex(ei:GetIndex())local es=client.GetPlayerInfo(ei:GetIndex())["UserID"]if en.get("targetmode")==0 and N[es]then ei:SetProp("m_iTeamNum",ei:GetProp("m_iPendingTeamNum"))N[es]=nil elseif en.get("targetmode")==1 then ei:SetProp("m_iTeamNum",ee:GetTeamNumber())N[es]=true elseif en.get("targetmode")==2 then if ei:GetProp("m_iPendingTeamNum")==ee:GetTeamNumber()then ei:SetProp("m_iTeamNum",(ee:GetTeamNumber()-1)%2+2)N[es]=true else if N[es]then ei:SetProp("m_iTeamNum",ei:GetProp("m_iPendingTeamNum"))N[es]=nil end if not O and ei:GetTeamNumber()~=ee:GetTeamNumber()and gui.GetValue("rbot.master")then local eh=ee:GetAbsOrigin()+ee:GetPropVector("localdata","m_vecViewOffset[0]")local er=ei:GetHitboxPosition(5)local ed=engine.TraceLine(eh,er,0xFFFFFFFF)if ed.entity:IsPlayer()then engine.SetViewAngles((er-eh):Angles())gui.SetValue("rbot.aim.target.fov",I)gui.SetValue("rbot.aim.target.lock",true)A=ei O=true end end end end eo=true until true if not eo then break end end end)callbacks.Register("FireGameEvent","playerlist.extensions.Priority.FireGameEvent",function(Z)if Z:GetName()=="player_death"and O then if client.GetPlayerIndexByUserID(Z:GetInt("userid"))==A:GetIndex()then O=false A=nil gui.SetValue("rbot.aim.target.fov",180)return gui.SetValue("rbot.aim.target.lock",false)end end end)local S=plist.gui.Multibox("Force ...")do local Z=plist.gui.Multibox_Checkbox(S,"force.baim","BAIM",false)Z:SetDescription("Sets bodyaim to priority.")end do local Z=plist.gui.Multibox_Checkbox(S,"force.safepoint","Safepoint",false)Z:SetDescription("Shoots only on safepoint.")end local H={"asniper","hpistol","lmg","pistol","rifle","scout","shared","shotgun","smg","sniper","zeus"}local R={applied=false}local D D=function()if R.applied then print("[PLAYERLIST] WARNING: Force baim has already been applied.")end for Z=1,#H do local ee=H[Z]if gui.GetValue("rbot.hitscan.mode."..tostring(ee)..".bodyaim")~=1 then R[ee]=gui.GetValue("rbot.hitscan.mode."..tostring(ee)..".bodyaim")gui.SetValue("rbot.hitscan.mode."..tostring(ee)..".bodyaim",1)end end R.applied=true end local L L=function()if not R.applied then print("[PLAYERLIST] WARNING: Force baim hasn't been applied.")end for Z,ee in pairs(R)do local et=false repeat if Z=="applied"then et=true break end gui.SetValue("rbot.hitscan.mode."..tostring(Z)..".bodyaim",ee)et=true until true if not et then break end end R={applied=false}end local U={applied=false}local C={"delayshot","delayshotbody","delayshotlimbs"}local M M=function()if U.applied then print("[PLAYERLIST] WARNING: Force safepoint has already been applied.")end for Z=1,#H do local ee=H[Z]for et=1,#C do local ea=C[et]if gui.GetValue("rbot.hitscan.mode."..tostring(ee).."."..tostring(ea))~=1 then U[tostring(ee).."."..tostring(ea)]=gui.GetValue("rbot.hitscan.mode."..tostring(ee).."."..tostring(ea))gui.SetValue("rbot.hitscan.mode."..tostring(ee).."."..tostring(ea),1)end end end U.applied=true end local F F=function()if not U.applied then print("[PLAYERLIST] WARNING: Force safepoint hasn't been applied.")end for Z,ee in pairs(U)do local et=false repeat if Z=="applied"then et=true break end gui.SetValue("rbot.hitscan.mode."..tostring(Z),ee)et=true until true if not et then break end end U={applied=false}end local W=nil callbacks.Register("AimbotTarget","playerlist.extensions.FBSP.AimbotTarget",function(Z)if not Z:GetIndex()then return end W=Z local ee=plist.GetByIndex(Z:GetIndex())if ee.get("force.baim")then if not R.applied then D()end elseif R.applied then L()end if ee.get("force.safepoint")then if not U.applied then return M()end elseif U.applied then return F()end end)callbacks.Register("FireGameEvent","playerlist.extensions.FBSP.FireGameEvent",function(Z)if Z:GetName()=="player_death"and W and client.GetPlayerIndexByUserID(Z:GetInt("userid"))==W:GetIndex()then W=nil if R.applied then L()end if U.applied then return F()end end end)local Y=plist.gui.Multibox("ESP Options")local P do local Z=plist.gui.Multibox_Checkbox(Y,"esp.box","Box",false)Z:SetDescription("Draw box around entity.")P=Z end plist.gui.Multibox_ColorPicker(P,"esp.box.clr","Box Color",0xFF,0x00,0x00,0xFF)local V do local Z=plist.gui.Multibox_Checkbox(Y,"esp.chams","Chams",false)Z:SetDescription("Draw chams onto the model. Colors are: visible / invisible")V=Z end plist.gui.Multibox_ColorPicker(V,"esp.chams.invclr","Invisible Color",0xFF,0xFF,0x00,0xFF)plist.gui.Multibox_ColorPicker(V,"esp.chams.visclr","Visible Color",0x00,0xFF,0x00,0xFF)local B do local Z=plist.gui.Multibox_Checkbox(Y,"esp.name","Name",false)Z:SetDescription("Draw entity name.")B=Z end plist.gui.Multibox_ColorPicker(B,"esp.name.clr","Color",0xFF,0xFF,0xFF,0xFF)local G do local Z=plist.gui.Multibox_Checkbox(Y,"esp.healthbar","Healthbar",false)Z:SetDescription("Draw entity healthbar. 0% alpha = health based")G=Z end plist.gui.Multibox_ColorPicker(G,"esp.healthbar.clr","Color",0x00,0x00,0x00,0x00)local K do local Z=plist.gui.Multibox_Checkbox(Y,"esp.ammo","Ammo",false)Z:SetDescription("Draw amount of money left in weapon.")K=Z end plist.gui.Multibox_ColorPicker(K,"esp.ammo.clr","Color",0xFF,0xFF,0xFF,0xFF)local Q={weapon_glock=20,weapon_usp_silencer=12,weapon_hkp2000=13,weapon_revolver=8,weapon_cz75a=12,weapon_deagle=7,weapon_elite=30,weapon_fiveseven=20,weapon_p250=13,weapon_tec9=18,weapon_mac10=30,weapon_mp7=30,weapon_mp9=30,weapon_mp5sd=30,weapon_bizon=64,weapon_p90=50,weapon_ump45=25,weapon_mag7=5,weapon_nova=8,weapon_sawedoff=8,weapon_xn1014=7,weapon_m249=100,weapon_negev=150,weapon_ak47=30,weapon_aug=30,weapon_famas=25,weapon_galilar=35,weapon_m4a1_silencer=25,weapon_m4a1=30,weapon_sg556=30,weapon_ssg08=10,weapon_scar20=20,weapon_g3sg1=20,weapon_awp=10,weapon_taser=1}callbacks.Register("DrawESP","playerlist.extensions.PPE.DrawESP",function(Z)local ee=Z:GetEntity()if not ee:IsPlayer()then return end local et=plist.GetByIndex(ee:GetIndex())if et.get("esp.box")then draw.Color(unpack(et.get("esp.box.clr")))draw.OutlinedRect(Z:GetRect())end if et.get("esp.name")then Z:Color(unpack(et.get("esp.name.clr")))Z:AddTextTop(ee:GetName())end if et.get("esp.healthbar")then local ea=ee:GetHealth()/ee:GetMaxHealth()if et.get("esp.healthbar.clr")[4]==0x00 then Z:Color(0xFF-0xFF*ea,0xFF*ea,0x00,0xFF)else Z:Color(unpack(et.get("esp.healthbar.clr")))end Z:AddBarLeft(ea,ee:GetHealth())end if et.get("esp.ammo")then local ea=ee:GetPropEntity("m_hActiveWeapon")if ea then local eo=ea:GetProp("m_iClip1")if eo>=0 then if Q[tostring(ea)]==nil then print("[Player List] [WARNING] Unknow weapon: "..tostring(ea))Q[tostring(ea)]=eo end Z:Color(unpack(et.get("esp.ammo.clr")))return Z:AddBarBottom(eo/Q[tostring(ea)],eo)end end end end)local J={}local X X=function(Z,ee)local et=Z[1]+Z[2]*256+Z[3]*65536+Z[4]*16777216+ee*4294967296 if J[et]then return J[et]end local ea=([[        "VertexLitGeneric" {
        "$basetexture" "vgui/white_additive"
        "$color" "[%s %s %s]"
        "$alpha" "%s"
        "$ignorez" "%s"
    }]]):format(Z[1]/255,Z[2]/255,Z[3]/255,Z[4]/255,ee)J[et]=materials.Create("Chams",ea)return J[et]end callbacks.Register("DrawModel","playerlist.extensions.PPE.DrawModel",function(Z)local ee=Z:GetEntity()if not ee or not ee:IsPlayer()then return end local et=plist.GetByIndex(ee:GetIndex())if et.get("esp.chams")then if et.get("esp.chams.invclr")[4]>0 then Z:ForcedMaterialOverride(X(et.get("esp.chams.invclr"),1))Z:DrawExtraPass()end if et.get("esp.chams.visclr")[4]>0 then return Z:ForcedMaterialOverride(X(et.get("esp.chams.visclr"),0))end end end)do local Z=plist.gui.Checkbox("reveal_on_radar","Reveal on Radar",false)Z:SetDescription("Reveal player on radar.")end callbacks.Register("CreateMove","playerlist.extensions.ROR.CreateMove",function(Z)local ee=entities.GetLocalPlayer()local et=entities.FindByClass("CCSPlayer")for ea=1,#et do local eo=false repeat local ei=et[ea]if not ei:IsAlive()then eo=true break end local en=plist.GetByIndex(ei:GetIndex())ei:SetProp("m_bSpotted",en.get("reveal_on_radar"and 1 or 0))eo=true until true if not eo then break end end end)