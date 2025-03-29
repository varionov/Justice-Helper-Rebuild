---@diagnostic disable: undefined-global, need-check-nil, lowercase-global, cast-local-type, unused-local

script_name("Justice Helper")
script_description('This is a Cross-platform Lua script helper for Arizona RP players who work in the Ministry of Justice (PD and FBI) ??and the Ministry of Defense (Army)')
script_author("Varionov")
script_version("2.1 Free")

require('lib.moonloader')
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local ffi = require('ffi')
local sizeX, sizeY = getScreenResolution()

print('[Justice Helper] ������ ���������������. ������: ' .. thisScript().version)
-------------------------------------------- JSON SETTINGS ---------------------------------------------
local configDirectory = getWorkingDirectory():gsub('\\','/') .. "/Justice Helper"
local path_helper = getWorkingDirectory():gsub('\\','/') .. "/Justice Helper.lua"
local path_settings = configDirectory .. "/Settings.json"
local settings = {}
local default_settings = {
	general = {
		version = thisScript().version,
		accent_enable = false,
		auto_mask = false,
		rp_chat = true,
        rp_gun = true,
		auto_doklad_patrool = false,
		auto_doklad_damage = false,
		auto_doklad_arrest = false,
		auto_change_code_siren = false,
		auto_update_wanteds = false,
		auto_find_wanteds = false,
		auto_update_members = false,
		auto_notify_payday = false,
		auto_notify_port = false,
		auto_accept_docs = false,
		auto_uval = false,
		auto_time = false,
		auto_clicker_situation = false,
		auto_documentation = false,
		moonmonet_theme_enable = true,
		moonmonet_theme_color = 40703,
		mobile_fastmenu_button = true,
		mobile_stop_button = true,
		mobile_meg_button = true,
		use_binds = true,
		use_info_menu = true,
		use_taser_menu = true,
		bind_mainmenu = '[113]',
		bind_fastmenu = '[69]',
		bind_leader_fastmenu = '[71]',
		bind_command_stop = '[123]',
		custom_dpi = 1.0,
		autofind_dpi = false,
	},
	player_info = {
		name_surname = '',
		accent = '[����������� ������]:',
		fraction = '����������',
		fraction_tag = '����������',
		fraction_rank = '����������',
		fraction_rank_number = 0,
		sex = '����������',
	},
	deportament = {
		dep_fm = '-',
		dep_tag1 = '',
		dep_tag2 = '[����]',
		dep_tags = {
			"[����]",
			"[����������]",
			"[���������]",
			"[���������]",
			'skip',
			"[��]",
			"[���.���.]",
			"[����]",
			"[����]",
			"[����]",
			"[����]",
			"[����]",
			"[���]",
			'skip',
			"[��]",
			"[���.�������]",
			"[���]",
			"[���]",
			"[���]",
			'skip',
			"[��]",
			"[���]",
			"[���.�����.]",
			"[����]",
			"[����]",
			"[����]",
			"[���]",
			"[��]",
			'skip',
			"[��]",
			"[��]",
			"[��]",
			"[���-��]",
			"[����������]",
			"[��������]",
			'skip',
			"[���]",
			"[��� ��]",
			"[��� ��]",
			"[��� ��]",
		},
		dep_tags_en = {
			"[ALL]",
			'skip',
			"[MJ]",
			"[Min.Just.]",
			"[LSPD]",
			"[SFPD]",
			"[LVPD]",
			"[RCSD]",
			"[SWAT]",
			"[FBI]",
			'skip',
			"[MD]",
			"[Mid.Def.]",
			"[LSa]",
			"[SFa]",
			"[MSP]",
			'skip',
			"[MH]",
			"[MHF]",
			"[Min.Healt]",
			"[LSMC]",
			"[SFMC]",
			"[LVMC]",
			"[JMC]",
			"[FD]",
			'skip',
			"[GOV]",
			"[Prosecutor]",
			"[LC]",
			"[INS]",
			'skip',
			"[CNN]",
			"[CNN LS]",
			"[CNN LV]",
			"[CNN SF]",
		},
		dep_tags_custom = {},
		dep_fms = {
			'-',
			'- �.�. -',
		},
		dep_fms_custom = {},
	},
	windows_pos = {
		megafon = {x = sizeX / 8.5, y = sizeY / 2.1},
		info_menu = {x = sizeX * 0.03, y = sizeY * 0.53},
		patrool_menu = {x = sizeX / 8, y = sizeY - sizeY/10},
		wanteds_menu = {x = sizeX / 1.2, y = sizeY / 2},
		mobile_fastmenu_button = {x = sizeX / 8.5, y = sizeY / 2.3},
		taser = {x = sizeX / 4.2, y = sizeY / 2.1},
	}
}

function load_settings()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(path_settings) then
        settings = default_settings
		print('[Justice Helper] ���� � ����������� �� ������, ��������� ����������� ���������!')
    else
        local file = io.open(path_settings, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				settings = default_settings
				print('[Justice Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					settings = loaded
					-- for category, _ in pairs(default_settings) do
					-- 	if settings[category] == nil then
					-- 		settings[category] = {}
					-- 	end
					-- 	for key, value in pairs(default_settings[category]) do
					-- 		if settings[category][key] == nil then
					-- 			settings[category][key] = value
					-- 		end
					-- 	end
					-- end
					if settings.general.version ~= thisScript().version then
						print('[Justice Helper] ����� ������, ����� ��������!')
						settings = default_settings
						save_settings()
						reload_script = true
					else
						print('[Justice Helper] ��������� ������� ���������!')
					end
				else
					print('[Justice Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
				end
			end
        else
            settings = default_settings
			print('[Justice Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
        end
    end
end
function save_settings()
    local file, errstr = io.open(path_settings, 'w')
    if file then
        local result, encoded = pcall(encodeJson, settings)
        file:write(result and encoded or "")
        file:close()
		print('[Justice Helper] ��������� ���������!')
        return result
    else
        print('[Justice Helper] �� ������� ��������� ��������� �������, ������: ', errstr)
        return false
    end
end
load_settings()
-------------------------------------------- JSON MY NOTES ---------------------------------------------
local notes = {
	note = {
		{ note_name = '��������', note_text = '������ ���� �������� ����� ���� ������, ��� �������:&- ���� � ��� ���� ����� (���/�����) �� � ��� ����� -20 ��������� ��&- ���� � ��� ���� ������� �� � ��� ����� -20 ��������� ��&- ��-�� ����� ��������� (�� ��������) � ��� ����� -10 ��������� ��&&��� �������� ���� ��������:&- �������� � ���� ����� � ������ ����� ����� +7 ��������� �� &( �� 20 ������� ��� ���� ����� Martelli )&- �������� \"������� �����\" ����� ����� +15 ��������� ��&- ������ ��������� �� \"�� �������\" ����� ����� �� +25 ��������� ��&- ����������� �� ���� ������'},
		{ note_name = '���-����', note_text = '10-1 - ���� ���� �������� �� ���������.&10-2 - ����� � �������.&10-2R - �������� �������.&10-3 - �������������.&10-4 - �������.&10-5 - ���������.&10-6 - �� �������/�������/���.&10-7 - ��������.&10-8 - �� ��������/�����.&10-14 - ������ ���������������.&10-15 - ������������� ����������.&10-18 - ��������� ��������� �������������� ������.&10-20 - �������.&10-21 - ������ � ���������������.&10-22 - ������������ � �������.&10-27 - ����� ���������� �������.&10-30 - �������-������������ ������������.&10-40 - ������� ��������� ����� (����� 4).&10-41 - ����������� ����������.&10-46 - ������� �����.&10-55 - ������� ����.&10-57 VICTOR - ������ �� �����������.&10-57 FOXTROT - ����� ������.&10-66 - ������� ���� ����������� �����.&10-70 - ������ ���������.&10-71 - ������ ����������� ���������.&10-88 - ������/��.&10-99 - �������� �������������.&10-100 �������� ���������� ��� �������.' },
		{ note_name = '������������ ����', note_text = 'CODE 0 - ������ �����.&CODE 1 - ������ � ����������� ���������, ����� ������ ���� ������.&CODE 2 - ������� ����� [��� �����/������������/���������� ���].&CODE 2 HIGHT - ������������ ����� [��� �����/������������/���������� ���].&CODE 3 - ������� ����� [������, �����������, ������������� ���].&CODE 4 - ���������, ������ �� ���������.&Code 4 ADAM - ������ �� ���������, �� ������� ���������� ������ ���� ������ ������� ������.&CODE 5 - �������� ��������� �������� �� �������� �����.&CODE 6 - ������������ �� ����� [������� ������� � �������,��������, 911].&CODE 7 - ������� �� ����.&CODE 30 - ������������ "�����" ������������ �� ����� ������������.&CODE 30 RINGER - ������������ "������� ������������ �� ����� ������������.&CODE 37 - ����������� ��������� ������������� ��������.&�ode TOM - ������� ��������� ������.' },
		{ note_name = '���������� �������', note_text = '��������:&ADAM [A] - ������� �� 2/3 �������� �� �������.&LINCOLN [L] - ��������� ������� �� �������.&MARY [M] - ��������� ������� �� ���������.&HENRY [H] - ��������������� �������.&AIR [AIR] - ��������� �������.&Air Support Division [ASD] - ��������� ���������.&&��������������:&CHARLIE [C] - ������ �������.&ROBERT [R] - ����� ����������.&SUPERVISOR [SV] - ����������� ������.&DAVID [D] - C���������� ����� SWAT.&EDWARD [E] - ��������� �������.&NORA [N] - ��������������� ������� �������.',},
	}
}
local path_notes = configDirectory .. "/Notes.json"
function load_notes()
	if doesFileExist(path_notes) then
		local file, errstr = io.open(path_notes, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[Justice Helper] �� ������� ������� ���� � ���������!')
				print('[Justice Helper] �������: ���� ���� ������')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					notes = loaded
					print('[Justice Helper] ������� ����������������!')
				else
					print('[Justice Helper] �� ������� ������� ���� � ���������!')
					print('[Justice Helper] �������: �� ������� ������������ json (������ � �����)')
				end
			end
        else
			print('[Justice Helper] �� ������� ������� ���� � ���������!')
			print('[Justice Helper] �������: ')
        end
	else
		print('[Justice Helper] �� ������� ������� ���� � ���������!')
		print('[Justice Helper] �������: ����� ����� ���� � ����� '..configDirectory)
	end
end
function save_notes()
    local file, errstr = io.open(path_notes, 'w')
    if file then
        local result, encoded = pcall(encodeJson, notes)
        file:write(result and encoded or "")
        file:close()
		print('[Justice Helper] ������� ���������!')
        return result
    else
        print('[Justice Helper] �� ������� ��������� �������, ������: ', errstr)
        return false
    end
end
load_notes()
-------------------------------------------- JSON RP GUNS ---------------------------------------------
local rp_guns = {
    {id = 0, name = '������', enable = true, rpTake = 2},
    {id = 1, name = '�������', enable = true, rpTake = 2},
    {id = 2, name = '������ ��� ������', enable = true, rpTake = 1},
    {id = 3, name = '�������', enable = true, rpTake = 3},
    {id = 4, name = '������ ���', enable = true, rpTake = 3},
    {id = 5, name = '����', enable = true, rpTake = 1},
    {id = 6, name = '������', enable = true, rpTake = 1},
    {id = 7, name = '���', enable = true, rpTake = 1},
    {id = 8, name = '������', enable = true, rpTake = 1},
    {id = 9, name = '���������', enable = true, rpTake = 1},
    {id = 10, name = '�����', enable = true, rpTake = 2},
    {id = 11, name = '�����', enable = true, rpTake = 2},
    {id = 12, name = '��������', enable = true, rpTake = 2},
    {id = 13, name = '��������', enable = true, rpTake = 2},
    {id = 14, name = '����� ������', enable = true, rpTake = 1},
    {id = 15, name = '������', enable = true, rpTake = 1},
    {id = 16, name = '���������� �������', enable = true, rpTake = 3},
    {id = 17, name = '������� �������', enable = true, rpTake = 3},
    {id = 18, name = '�������� ��������', enable = true, rpTake = 3},
    {id = 22, name = '�������� Colt45', enable = true, rpTake = 4},
    {id = 23, name = "������������ Taser-X26P", enable = true, rpTake = 4},
    {id = 24, name = '�������� Desert Eagle', enable = true, rpTake = 4},
    {id = 25, name = '��������', enable = true, rpTake = 1},
    {id = 26, name = '�����', enable = true, rpTake = 1},
    {id = 27, name = '���������� �����', enable = true, rpTake = 1},
    {id = 28, name = '��������-������ Micro Uzi', enable = true, rpTake = 4},
    {id = 29, name = '��������-������ MP5', enable = true, rpTake = 4},
    {id = 30, name = '������� AK-47', enable = true, rpTake = 1},
    {id = 31, name = '������� M4', enable = true, rpTake = 1},
    {id = 32, name = '��������-������ Tec-9', enable = true, rpTake = 4},
    {id = 33, name = '�������� Rifle', enable = true, rpTake = 1},
    {id = 34, name = '����������� �������� Rifle', enable = true, rpTake = 1},
    {id = 35, name = '������ ��������������� ������', enable = true, rpTake = 1},
    {id = 36, name = '���������� ��� ������� �����', enable = true, rpTake = 1},
    {id = 37, name = '������', enable = true, rpTake = 1},
    {id = 38, name = '�������', enable = true, rpTake = 1},
    {id = 39, name = '�������', enable = true, rpTake = 3},
    {id = 40, name = '���������', enable = true, rpTake = 3},
    {id = 41, name = '�������� ��������', enable = true, rpTake = 2},
    {id = 42, name = '������������', enable = true, rpTake = 1},
    {id = 43, name = '����������', enable = true, rpTake = 2},
    {id = 44, name = '������ ������� �������', enable = true, rpTake = 2},
    {id = 45, name = '����������', enable = true, rpTake = 2},
    {id = 46, name = '������ �������', enable = true, rpTake = 1},
    -- gta sa damage reason
    {id = 49, name = '����������', rpTake = 1},
    {id = 50, name = '������� ��������', rpTake = 1},
    {id = 51, name = '�����', rpTake = 1},
    {id = 54, name = '��������', rpTake = 1},
	-- ARZ CUSTOM GUN
    {id = 71, name = '�������� Desert Eagle Steel', enable = true, rpTake = 4},
    {id = 72, name = '�������� Desert Eagle Gold', enable = true, rpTake = 4},
    {id = 73, name = '�������� Glock Gradient', enable = true, rpTake = 4},
    {id = 74, name = '�������� Desert Eagle Flame', enable = true, rpTake = 4},
    {id = 75, name = '�������� Python Royal', enable = true, rpTake = 4},
    {id = 76, name = '�������� Python Silver', enable = true, rpTake = 4},
    {id = 77, name = '������� AK-47 Roses', enable = true, rpTake = 1},
    {id = 78, name = '������� AK-47 Gold', enable = true, rpTake = 1},
    {id = 79, name = '������ M249 Graffiti', enable = true, rpTake = 1},
    {id = 80, name = '������� �����', enable = true, rpTake = 1},
    {id = 81, name = '��������-������ Standart', enable = true, rpTake = 4},
    {id = 82, name = '������ M249', enable = true, rpTake = 1},
    {id = 83, name = '��������-������ Skorp', enable = true, rpTake = 4},
    {id = 84, name = '������� AKS-74 �����������', enable = true, rpTake = 1},
    {id = 85, name = '������� AK-47 �����������', enable = true, rpTake = 1},
    {id = 86, name = '�������� Rebecca', enable = true, rpTake = 1},
    {id = 87, name = '���������� �����', enable = true, rpTake = 1},
    {id = 88, name = '������� ���', enable = true, rpTake = 1},
    {id = 89, name = '���������� �����', enable = true, rpTake = 4},
    {id = 90, name = '���������� �������', enable = true, rpTake = 3},
    {id = 91, name = '����������� �������', enable = true, rpTake = 3},
    {id = 92, name = '����������� �������� McMillian TAC-50', enable = true, rpTake = 1},
	{id = 93, name = '���������� ��������', enable = true, rpTake = 4},
}
local rpTakeNames = {{"��-�� �����", "�� �����"}, {"�� �������", "� ������"}, {"�� �����", "�� ����"}, {"�� ������", "� ������"}}  
local path_rp_guns = configDirectory .. "/rp_guns.json"
function load_rp_guns()
	if doesFileExist(path_rp_guns) then
		local file, errstr = io.open(path_rp_guns, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[Justice Helper] �� ������� ������� ���� � �� ������!')
				print('[Justice Helper] �������: ���� ���� ������')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					rp_guns = loaded
					print('[Justice Helper] �� ���� ����������������!')
				else
					print('[Justice Helper] �� ������� ������� ���� � � �� ������!')
					print('[Justice Helper] �������: �� ������� ������������ json (������ � �����)')
				end
			end
        else
			print('[Justice Helper] �� ������� ������� ���� � rp ������!')
			print('[Justice Helper] �������: ')
        end
	else
		print('[Justice Helper] �� ������� ������� ���� � � �� ������!')
		print('[Justice Helper] �������: ����� ����� ���� � ����� '..configDirectory)
	end
end
function save_rp_guns()
    local file, errstr = io.open(path_rp_guns, 'w')
    if file then
        local result, encoded = pcall(encodeJson, rp_guns)
        file:write(result and encoded or "")
        file:close()
		print('[Justice Helper] �� ���� ���������!')
        return result
    else
        print('[Justice Helper] �� ������� ��������� �� ����, ������: ', errstr)
        return false
    end
end
load_rp_guns()
-------------------------------------------- JSON SMART UK ---------------------------------------------
local smart_uk = {}
local path_uk = configDirectory .. "/SmartUK.json"
function load_smart_uk()
	if doesFileExist(path_uk) then
		local file, errstr = io.open(path_uk, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[Justice Helper] �� ������� ������� ���� � ����� ��������!')
				print('[Justice Helper] �������: ���� ���� ������')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					smart_uk = loaded
					print('[Justice Helper] ����� ������ ���������������!')
				else
					print('[Justice Helper] �� ������� ������� ���� � ����� ��������!')
					print('[Justice Helper] �������: �� ������� ������������ json (������ � �����)')
				end
			end
        else
			print('[Justice Helper] �� ������� ������� ���� � ����� ��������!')
			print('[Justice Helper] �������: ')
        end
	else
		print('[Justice Helper] �� ������� ������� ���� � ����� ��������!')
		print('[Justice Helper] �������: ����� ����� ���� � ����� '..configDirectory)
	end
end
function save_smart_uk()
    local file, errstr = io.open(path_uk, 'w')
    if file then
        local result, encoded = pcall(encodeJson, smart_uk)
        file:write(result and encoded or "")
        file:close()
		print('[Justice Helper] ����� ������ �������!')
        return result
    else
        print('[Justice Helper] �� ������� ��������� ����� ������, ������: ', errstr)
        return false
    end
end
load_smart_uk()
-------------------------------------------- JSON SMART PDD ---------------------------------------------
local smart_pdd = {}
local path_pdd = configDirectory .. "/SmartPDD.json"
function load_smart_pdd()
	if doesFileExist(path_pdd) then
		local file, errstr = io.open(path_pdd, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[Justice Helper] �� ������� ������� ���� � ����� �������!')
				print('[Justice Helper] �������: ���� ���� ������')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					smart_pdd = loaded
					print('[Justice Helper] ����� ����� ���������������!')
				else
					print('[Justice Helper] �� ������� ������� ���� � ����� �������!')
					print('[Justice Helper] �������: �� ������� ������������ json (������ � �����)')
				end
			end
        else
			print('[Justice Helper] �� ������� ������� ���� � ����� �������!')
			print('[Justice Helper] �������: ', errstr)
        end
	else
		print('[Justice Helper] �� ������� ������� ���� � ����� �������!')
		print('[Justice Helper] �������: ����� ����� ���� � ����� '..configDirectory)
	end
end
function save_smart_pdd()
    local file, errstr = io.open(path_pdd, 'w')
    if file then
        local result, encoded = pcall(encodeJson, smart_pdd)
        file:write(result and encoded or "")
        file:close()
		print('[Justice Helper] ����� ������ ���������!')
        return result
    else
        print('[Justice Helper] �� ������� ��������� ����� ������, ������: ', errstr)
        return false
    end
end
load_smart_pdd()
-------------------------------------------- JSON COMMANDS ---------------------------------------------
local commands = {
	commands = {
		{ cmd = '55', description = '���������� 10-55', text = '/r {my_doklad_nick} �� CONTROL. ������� 10-55 � ������ {get_area} ({get_square}), �ODE 4.&/m ��������{get_storecar_model}, ��������!&/m ���������� ������� �������� � ���������� � �������!&/m ����� ��������� ��������� ���������, ������� ���� �� ���� � �� �������� �� ����������.&/m � ������ ������������ �� ������ ��������� � ������, � �� ��� ����� ������ �����!', arg = '', enable = true, waiting = '1.500', bind = "[101]" },
		{ cmd = '66', description = '���������� 10-66', text = '/r {my_doklad_nick} �� CONTROL. ������� 10-66 � ������ {get_area} ({get_square}), �ODE 3!&/m ��������{get_storecar_model}, ��������!&/m ���������� ������� �������� � ���������� � �������!&/m � ������ ������������ �� ������ ��������� � ������, � �� ��� ����� ������ �����!', arg = '', enable = true, waiting = '1.500', bind = "[102]" },
		{ cmd = 'zd' , description = '����������� ������' , text = '����������� {get_ru_nick({arg_id})}&� {my_ru_nick} - {fraction_rank} {fraction_tag}&��� � ���� ��� ������?', arg = '{arg_id}' , enable = true , waiting = '1.500', bind = "{}" },
		{ cmd = 'bk' , description = '������ ������ � ������������' , text = '/r {my_doklad_nick} �� CONTROL. ������ ����� ������, ������� ���� ����������. CODE 1&/me ������ ���� ��� � ���������� ���������� � ���� ������ {fraction_tag}&/bk 10-20', arg = '' , enable = true , waiting = '1.500', bind = "{}" },
		{ cmd = 'siren' , description = '���/���� ������� � �/�' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.500', bind = "{}" },
        { cmd = 'cure' , description = '������� ������ �� ������' ,  text = '/me ����������� ��� ���������, � ����������� ��� ����� �� ������ �������&/cure {arg_id}&/do ����� �����������.&/me �������� ������ �������� �������� ������ ������, ����� �� ������� �������� �����&/do ������ ��������� ����� ������ �������� ������ ������.&/do ������� ������ � ��������.&/todo �������*��������' , arg = '{arg_id}' , enable = true , waiting = '1.500' , bind = "{}"  },
		{ cmd = 'time' , description = '���������� �����' ,  text = '/me ��������{sex} �� ���� ���� � ���������{sex} �����&/time&/do �� ����� �������� ����� {get_time}.' , arg = '' , enable = true, waiting = '1.500' , bind = "{}"  },
        { cmd = 'pas' , description = '��������� ��������� (PD)' ,  text = '�����������, ���������� {fraction_tag}, � {fraction_rank} {my_ru_nick}&/do C���� �� ����� ����� ������������, ������ ������� ������� � ������.&/me  ������ ��� ������������� �� �������&/showbadge {arg_id}&����� ���������� ��������, �������������� ���� ��������.&/n {get_nick({arg_id})}, ������� /showpass {my_id}' , arg = '{arg_id}' , enable = true , waiting = '1.500' , bind = "{}", in_fastmenu = true  },
        { cmd = 'doc' , description = '��������� ��������� (FBI)' ,  text = '�����������, � {fraction_rank} {fraction_tag}&/do C���� �� ����� ����-����� ���.&/me ��������� ������� �� ���� ����-����� �� �����&����� ���������� ��������, �������������� ���� ��������.&/n {get_nick({arg_id})}, ������� /showpass {my_id} ��� /showbadge {my_id}' , arg = '{arg_id}' , enable = false , waiting = '1.500' , bind = "{}"  },
        { cmd = 'ts' , description = '�������� �����' ,  text = '/do ����� ��������� � ����� ���������� � ��������� �������.&/me ������ �� ���������� ������� ����� ��������� � �����.&/me ��������� � ����� ������ ����������&/writeticket {arg_id} {arg2}&/do ����� ��������� ��������.&/me ������� ����� �� ������� ���������� ��� ���������� ������' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.500' , bind = "{}"  },
        { cmd = 'pr' , description = '������ �� �������' ,  text = '/me ������ ���� ��� � ������� � ���� ������ {fraction_tag}&/me ��������� ���� ���������� N-{arg_id} � �������� �� ������ ������������ ��������������&/pursuit {arg_id}&/me ������� � ���� ������ {fraction_tag} � �������� ��� ������� ��� �� ������� ���������' , arg = '{arg_id}' , enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'find' , description = '����� ������' ,  text = '/do ��� ����� �� ������� ���������.&/me ������ ���� ��� � �������� ���&/me ������� � ���� ������ {fraction_tag} � ��������� ���� ���������� N-{arg_id}&/do ������ ������� ��������.&/me ������������� � ���� ��������� ���������� ���������� N-{arg_id}&/do ��������� ������� ���������� � �������� ��������� ����.&/find {arg_id}&/me ������� � ���� ������ {fraction_tag} � �������� ��� ������� ��� �� ������� ���������' , arg = '{arg_id}' , enable = true, waiting = '1.500' , bind = "{}"  },
        { cmd = 'su' , description = '������ ������' ,  text = '/me ������ ���� ��� � ��������� ���� ������ ������������&/me ������ ��������� � ���� ������ ������������&/do ���������� ������ � ���� ������ ������������.&/su {arg_id} {arg2} {arg3}&/z {arg_id}' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.500' , bind = "{}" },
        { cmd = 'fsu' , description = '��������� ������ �������' ,  text = '/do ����� �� ����������� �����.&/me ������ ����� � ����������� � �����������&/me ������� ���������� ������ �� �������� �������� � ���� ������ ������������&/r {my_doklad_nick} �� CONTROL.&/r ����� �������� � ������ {arg2} ������� ���� N{arg_id}. �������: {arg3}' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'givefsu' , description = '������ ������� �� ������� �������' ,  text = '/do ����� �� ����������� �����.&/me ������ ����� � ����������� � �������� ��� ��������� ������&/r 10-4, ����� ������ �� ������� ������� {get_rp_nick({arg_id})}!&/me ������ ���� ��� � ��������� ���� ������ ������������&/me ������ ��������� � ���� ������ ������������&/do ���������� ������ � ���� ������ �����������.&/su {get_form_su} (�� ������� ������� {get_rp_nick({arg_id})})&' , arg = '{arg_id}' , enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'unsu' , description = '�������� ������' ,  text = '/me ������ ���� ��� � ��������� ���� ������ ������������&/me ���� ���� N{arg_id} � ������ ��������� � ���� ������ ������������&/unsu {arg_id} {arg2} {arg3}&/do ���������� ������� ������� �������.' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'clear' , description = '����� ������' ,  text = '/me ������ ���� ��� � ��������� ���� ������ ������������&/me ���� ���� N{arg_id} � ������ ��������� � ���� ������ ������������&/clear {arg_id}&/do ���� N{arg_id} ������ �� ��������� � ������ ������������� ������������.' , arg = '{arg_id}' , enable = true, waiting = '1.500' , bind = "{}"  },
        { cmd = 'cuff' , description = '������ ���������' ,  text = '/do ��������� �� ����������� �����.&/me ������� ��������� � ����� � �������� �� �� ������������&/cuff {arg_id}&/do ����������� � ����������.' , arg = '{arg_id}' , enable = true , waiting = '1.500', bind = "{}" , in_fastmenu = true},
        { cmd = 'uncuff' , description = '����� ���������' ,  text = '/do �� ����������� ����� ����������� ����� �� ����������.&/me ������� � ����� ���� �� ���������� � ��������� �� � ��������� ������������&/me ������������ ���� � ���������� � ������� �� � ������������&&/uncuff {arg_id}&/do ��������� ����� � ������������&/me ����� ���� � ��������� ������� �� ����������� ����', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true },
        { cmd = 'gtm' , description = '������� �� �����' ,  text = '/me ���������� ������������ �� ���� � ���� ��� �� �����&/gotome {arg_id}&/do ����������� ��� � ������.', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true },
        { cmd = 'ungtm' , description = '��������� ����� �� �����' ,  text = '/me ��������� ���� ������������ � �������� ����� ��� �� �����&/ungotome {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true },
		{ cmd = 'gcuff' , description = '������ ��������� � ����� �� �����' ,  text = '/do ��������� �� ����������� �����.&/me ������� ��������� � ����� � �������� �� �� ������������&/cuff {arg_id}&/do ����������� � ����������.&/me ���������� ������������ �� ���� � ���� ��� �� �����&/do ����������� ��� � ������.&/gotome {arg_id}' , arg = '{arg_id}' , enable = true , waiting = '1.500', bind = "{}" },
		{ cmd = 'bot' , description = '������ ������� � ������ (����� ����������)' ,  text = '/me ������ ��� ����������� ���������� ������� ��� ������ ����������&/todo �� ��� ���� ����������?!*������ ������� � {get_rp_nick({arg_id})}&/bot {arg_id}' , arg = '{arg_id}' , enable = true , waiting = '1.500', bind = "{}", in_fastmenu = true },
		{ cmd = 'ss' , description = '��������' ,  text = '/s ���� ������� ���� �����, �������� {fraction_tag}!', arg = '', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 't' , description = '������� �����' ,  text = '/taser', arg = '', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 'frl' , description = '��������� �����' ,  text = '������ � ������� � ��� ������� ������ ��� ������ ������ ���������, �� ����������.&/me ����������� ���� ������������ ��������&/me ����������� ������� ������������ ��������', arg = '', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 'fr' , description = '������ �����' ,  text = '/do ��������� �������� �� ����������� �����.&/todo ������ � �������� ����� ���, �� ������� ����������� ���������*������� ��������� ��������&/me ����������� ���� � ������� ������������ ��������&/me ������ �� �������� ������������ ��� ��� ���� ��� ��������&/me ����������� ����������� ��� ��������� ���� � ������������ ��������&/frisk {arg_id}&/me ������� ��������� �������� � ������� �� �� ����������� �����&/do ������� � ������ � ��������� �������.&/me ����� � ���� ������� � ������, � ���������� ��� ���������� ��� �����&/me ������ �������, ������� ������� � ������ � ��������� ������', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true },
		{ cmd = 'take' , description = '������� ��������� ������' , text = '/do � �������� ���������� ��������� ���-�����.&/me ������ �� �������� ���-����� � �������� ���&/me ����� � ���-����� ������� �������� ������������ ��������&/take {arg_id}&/do ������� �������� � ���-������.&/todo �������*������ ���-����� � ��������', arg = '{arg_id}' , enable = true , waiting = '1.500', bind = "{}", in_fastmenu = true  },
		{ cmd = 'camon' , description = '�������� c������ ���� ������' ,  text = '/do � ����� ����������� ������� ���� ������.&/me ���������� ��������� ���� �������{sex} ���� ������.&/do ������� ���� ������ �������� � ������� �� ������������.', arg = '', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 'camoff' , description = '��������� c������ ���� ������' ,  text = '/do � ����� ����������� ������� ���� ������.&/me ���������� ��������� ���� ��������{sex} ���� ������.&/do ������� ���� ������ ��������� � ������ �� ������� �� ������������.', arg = '', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 'inc' , description = '�������� � ���������' ,  text = '/me ��������� ������ ����� ����������&/todo ��������� ������, ����� �����*���������� ������������ � ������������ ��������&/incar {arg_id} {arg2}&/me ��������� ������ ����� ����������&/do ����������� � ������������ ��������.', arg = '{arg_id} {arg2}', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 'ej' , description = '��������� �� ����������',  text = '/me ��������� ����� ����������&/me �������� �������� ����� �� ����������&/eject {arg_id}&/me ��������� ����� ����������', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true },	
		{ cmd = 'pl' , description = '��������� ������ �� ��� ����������',  text = '/me ������ ������ ������� ��������� ����� ���������� ������������&/pull {arg_id}&/me ����������� ������������ �� ��� ���������� � ������ ������� �������� ���', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true },	
		{ cmd = 'mr' , description = '�������� ������� �������',  text = '�� ������ ����� ������� ��������.&��, ��� �� �������, ����� � ����� ������������ ������ ��� � ����.&�� ������ ����� �� 1 ���������� ������, �������� ��� ������ �������� ��������.&��� ������� ����� �������������� ��� �������.&���� �� �� ������ �������� ������ ��������, �� ����� ������������ ��� ������������.&��� ���� ���� �����?', arg = '', enable = true, waiting = '1.500', bind = "{}" },	
		{ cmd = 'unmask' , description = '����� ��������� � ������',  text = '/do ����������� � ���������.&/me ��������� ��������� � ������ ������������&/unmask {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}" , in_fastmenu = true},
		{ cmd = 'arr' , description = '���������� (� �������)',  text = '/me �������� ���� �������� �������� � ������ ��� ������� ����������&/me ������� � ������ ���������� ���������� ���������� � ��������� ������&/do �������� ���������� ��������.&/me �������� �� ����� �������� ����� ������� � ������� �� ������������ ��������&/arrest', arg = '', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true },
		{ cmd = 'drugs' , description = '�������� Drugs Test' ,  text = '/do �� ����������� ����� ��������� ��������.&/me ��������� �������� � ������ �� ���� ����� Drugs Test&/me ���� �� ������ �������� � �������� ������&/me �������� ��������� �������� � ��������&/me ������ �� �������� ���� �����-����-10 � ��������� ��� � ��������&/do � �������� � �������� ������� ��������� ����������� �������� � �����-����-10.&/me ���������� ���������� ����������� ��������&/do �� ����� �����-����-10 ���������� �������� ������� ����.&/todo ��, ��� ����� ���������*������ ��� ���������� �������� ������� ����&/me ������� �������� ������� � �������� � ��������� ���', arg = '', enable = true, waiting = '1.500', bind = "{}"},
		{ cmd = 'rbomb' , description = '�������������� �����' ,  text = '/do �� ����������� ����� ��������� ������� �����.&/me ������� � ����� ������� ����� � ������ ��� �� �����, ����� ��������� ���&/do �������� ������� ����� ��������� �� �����.&/me ������ �� �������� ������ ����� � ������ ������ � ������ ��� �� �����&/me ������ �� �������� ������ �������&/do �������� � �����, � ����� � ������ ������ �� �����.&/do �� ������� ����� ��������� 2 �������.&/me ����������� ������� � ����� � ������� �� ������ � �������� � �������&/me ��������� ��������� ���� ��������� ������ �����&/me ����������� ����������� �����&/do ������ ����� ����� ������������ �����.&/me ������ �� �������� ������ �������&/do ������� � �����.&/me ��������� ��������� ������� ��������� ������� ������ �����&/do ������ �����������, ������� �� ������� ����� �� ������.&/me ���� � ���� ����������� ����� � ������ ������ � ����� ��� ������������ ����� �����&/removebomb&/do ����� �����������.&/me ������� ������� � ������� ������� � �������� ����� � ��������� ���', arg = '', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 'delo' , description = '������������� ��������' ,  text = '/do ��������� ������ �� ����� ��������.&/todo ����, ��� �� ����� ���������*���������� ����� ��������&/me ����������� �  ������� ��� �����&{pause}&/me ������ �� �������� ����� ��� ������������� � �����&/me ��������� ����� ������������� ��������� ��� ��������� �����&{pause}&/me ���������� � ����� ������ ���� � ����� ��������&{pause}&/do ������� ������ ��������.&/me ���������� � ����� ������ ��������&{pause}&/do ����� ������������� �������� �������� ��������.&/todo �������, ������������� ��������*������ ����� � ������', arg = '', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 'dismiss' , description = '���������� (��� 6+ ���)' ,  text = '/do ��� ���������� �� ������� ���������.&/me ���� � ���� ���� ��� � �������� ���&/me ������� � ���� ������ {fraction_tag} � ��������� � ������ ���������� ������������ ������ �����������&/me ��������� ���� ������� ���������� � ������ � ���� ���������&/do ��������� ������� ���������.&/dismiss {arg_id} {arg2}&/me ������� � ���� ������ {fraction_tag} � �������� ��� ������� ��� �� ������� ���������', arg = '{arg_id} {arg2}', enable = false, waiting = '1.500', bind = "{}" },
		{ cmd = 'giveplate' , description = '������ ���������� �� ������' ,  text = '/do ����� � ����� � ��������� �������.&/me ������ ����� � ����� �� ���������� �������&/me ��������� ����� ��� ������ ���������� �� �������� ����&/do ����� �������� ��������.&/todo ��� ���� ����������, ������*������ ����� � ��������� ������&/giveplate {arg_id} {arg2}&/n {get_nick({arg_id})}, ������� /offer � �������, ����� �������� ���������� �� �������� ����.', arg = '{arg_id} {arg2}', enable = true, waiting = '1.500', bind = "{}" },
		{ cmd = 'agenda' , description = '������ �������� ������' ,  text = '/do � ����� � ����������� ����� ����� � ������ ����� � �������� ��������.&/me ������ �� ����� ����� � ������ ������� ��������&/me �������� ��������� ��� ����������� ���� �� ������ ��������&/do ��� ������ � �������� ���������.&/me ������ �� �������� ����� � ������ {fraction_tag}&/do ������� ����� �������� � �����.&/todo �� �������� ������� � ��������� �� ���������� ������ � �������*��������� ��������&/agenda {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true },
	},
	commands_manage = {
		{ cmd = 'book' , description = '������ ������ �������� �����' , text = '����������� � ��� ���� �������� �����, �� �� �����������!&������ � ��� ����� �, ��� �� ����� ������ �����, �������...&/me ������ �� ������ ������� ����� �������� ������ � ������ �� ��� ������ {fraction_tag}&/todo ������*��������� �������� ����� ������ ��������&/givewbook {arg_id} 100&/n {get_nick({arg_id})}, ������� ����������� � /offer ����� �������� �������� �����!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}", in_fastmenu = true  },
		{ cmd = 'inv' , description = '�������� ������ � �������' , text = '/do � ������� ���� ������ � ������� �� ����������.&/me ������ �� ������� ���� ���� �� ������ ������ �� ����������&/todo ��������, ��� ���� �� ����� ����������*��������� ���� �������� ��������&/invite {arg_id}&/n {get_ru_nick({arg_id})} , ������� ����������� � /offer ����� �������� ������!' , arg = '{arg_id}', enable = true, waiting = '1.500'  , bind = "{}", in_fastmenu = true  },
		{ cmd = 'rp' , description = '������ ���������� /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}", in_fastmenu = true  },
		{ cmd = 'gr' , description = '���������/��������� c���������' , text = '{show_rank_menu}&/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/giverank {arg_id} {get_rank}&/r ��������� {get_ru_nick({arg_id})} ������� ����� ���������!' , arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true   },
		{ cmd = 'vize' , description = '���������� Vice City ����� ����������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&{lmenu_vc_vize}' , arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}", in_fastmenu = true    },
		{ cmd = 'cjob' , description = '���������� ���������� ����������' , text = '/checkjobprogress {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}", in_fastmenu = true   },	
		{ cmd = 'fmutes' , description = '������ ��� ���������� (10 min)' , text = '/fmutes {arg_id} �.�.&/r ��������� {get_ru_nick({arg_id})} ������� ����� ������������ ����� �� 10 �����!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"   },
		{ cmd = 'funmute' , description = '����� ��� ����������' , text = '/funmute {arg_id}&/r ��������� {get_ru_nick({arg_id})} ������ ����� ������������ ������!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}", in_fastmenu = true   },
		{ cmd = 'vig' , description = '������ �������� c���������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/fwarn {arg_id} {arg2}&/r ���������� {get_ru_nick({arg_id})} ����� �������! �������: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.500'  , bind = "{}"  },
		{ cmd = 'unvig' , description = '������ �������� c���������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/unfwarn {arg_id}&/r ���������� {get_ru_nick({arg_id})} ��� ���� �������!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}" , in_fastmenu = true  },
		{ cmd = 'unv' , description = '���������� ������ �� �������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ���� ������� ������� � ������&/uninvite {arg_id} {arg2}&/r ��������� {get_ru_nick({arg_id})} ��� ������ �� �������: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.500' , bind = "{}"   },
		{ cmd = 'point' , description = '���������� ����� ��� �����������' , text = '/r ������ ������������ �� ���, ��������� ��� ����������...&/point' , arg = '', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'govka' , description = '������������� �� ����.�����' , text = '/d [{fraction_tag}] - [����]: ������� ��������������� �����, ������� �� ����������!&/gov [{fraction_tag}]: ������� ������� �����, ��������� ������ ������ �����!&/gov [{fraction_tag}]: ������ �������� ������������� � ����������� {fraction}}&/gov [{fraction_tag}]: ��� ���������� ��� ����� ����� ��������� � �������� � ��� � ����.&/d [{fraction_tag}] - [����]: ����������  ��������������� �����, ������� ��� �� ����������.' , arg = '', enable = true, waiting = '1.300', bind = "{}"  },
	}
}
local path_commands = configDirectory .. "/Commands.json"
function load_commands()
	if doesFileExist(path_commands) then
		local file, errstr = io.open(path_commands, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[Justice Helper] �� ������� ������� ���� � ���������!')
				print('[Justice Helper] �������: ���� ���� ������')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					if tostring(settings.general.version) ~= tostring(thisScript().version) then 
						print('[Justice Helper] ���������� ���� ������, ������ �������� ����� �������')
						local temp_commands = loaded
						for category, _ in pairs(commands) do
							if temp_commands[category] == nil then
								temp_commands[category] = {}
							end
							for key, value in pairs(commands[category]) do
								if temp_commands[category][key] == nil then
									temp_commands[category][key] = value
									print('[Justice Helper] �������� ������� /' .. value.cmd)
								end
							end
						end
						save_commands()
						thisScript():reload()
					else
						-- ��������� �������� �� .bind
						for _, command in pairs(loaded.commands) do
							if not command.bind then
								print('[Justice Helper] �������� ������� /' .. command.cmd .. ' (��������� ������)')
								command.bind = "{}"
							end
						end
						for _, command in pairs(loaded.commands_manage) do
							if not command.bind then
								print('[Justice Helper] �������� ������� /' .. command.cmd .. ' (��������� ������)')
								command.bind = "{}"
							end
						end
						commands = loaded
						save_commands()
					end
					print('[Justice Helper] ��� ������� ���������������!')
					
				else
					print('[Justice Helper] �� ������� ������� ���� � ���������!')
					print('[Justice Helper] �������: �� ������� ������������ json (������ � �����)')
				end
			end
        else
			print('[Justice Helper] �� ������� ������� ���� � ���������!')
			print('[Justice Helper] �������: ', errstr)
        end
	else
		print('[Justice Helper] �� ������� ������� ���� � ���������!')
		print('[Justice Helper] �������: ����� ����� ���� � ����� '..configDirectory)
		print('[Justice Helper] ������������� ����������� ������...')
		save_commands()
		load_commands()
	end
end
function save_commands()
    local file, errstr = io.open(path_commands, 'w')
    if file then
        local result, encoded = pcall(encodeJson, commands)
        file:write(result and encoded or "")
        file:close()
		print('[Justice Helper] ���� ������� ���������!')
        return result
    else
        print('[Justice Helper] �� ������� ��������� ������� �������, ������: ', errstr)
        return false
    end
end
load_commands()
-------------------------------------------- JSON ARZ VEHICLES ---------------------------------------------
local path_arzvehicles = configDirectory .. "/VehiclesArizona.json"
local arzvehicles = {}
function load_arzvehicles()
	if doesFileExist(path_arzvehicles) then
		local file, errstr = io.open(path_arzvehicles, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[Justice Helper] �� ������� ������� ���� � �������� ����� �������!')
				print('[Justice Helper] �������: ���� ���� ������')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					arzvehicles = loaded
					print('[Justice Helper] ������ ������ ����� ������� ����������������!')
				else
					print('[Justice Helper] �� ������� ������� ���� � �������� ����� �������!')
					print('[Justice Helper] �������: �� ������� ������������ json (������ � �����)')
				end
			end
        else
			print('[Justice Helper] �� ������� ������� ���� � �������� ����� �������!')
			print('[Justice Helper] �������: ', errstr)
        end
	else
		print('[Justice Helper] �� ������� ������� ���� � �������� ����� �������!')
		print('[Justice Helper] �������: ����� ����� ���� � ����� ' .. configDirectory)
	end
end
load_arzvehicles()
local colorNames = {
	[0] = "�������",
	[1] = "������",
	[2] = "����������",
	[3] = "���������",
	[4] = "����-�������",
	[5] = "������-����������",
	[6] = "���������-������",
	[7] = "������",
	[8] = "������-������",
	[9] = "����-�������",
	[10] = "����-������",
	[11] = "����-������",
	[12] = "��������-������",
	[13] = "���������-������",
	[14] = "����� ������-������",
	[15] = "������-������",
	[16] = "����-�������",
	[17] = "����������� ������-�����������",
	[18] = "����-��������",
	[19] = "����-�����������",
	[20] = "����-������",
	[21] = "������-���������",
	[22] = "�������-��������",
	[23] = "������",
	[24] = "�����������",
	[25] = "����-������",
	[26] = "������-������",
	[27] = "������-������",
	[28] = "����-������",
	[29] = "������-������",
	[30] = "�����-��������",
	[31] = "����-��������",
	[32] = "������-������ � ������� ��������",
	[33] = "����� �����",
	[34] = "������-������",
	[35] = "����-�����������",
	[36] = "����-������",
	[37] = "�����-�������",
	[38] = "������",
	[39] = "����-������",
	[40] = "����������-�������",
	[41] = "����-�����������",
	[42] = "���������-��������",
	[43] = "����-���������",
	[44] = "����-�������",
	[45] = "����-���������",
	[46] = "����-��������",
	[47] = "����������-������",
	[48] = "����������",
	[49] = "����-��������",
	[50] = "����������-������",
	[51] = "����-�������",
	[52] = "����-������",
	[53] = "����� ������ ������",
	[54] = "����-������",
	[55] = "����-�����������",
	[56] = "����-��������",
	[57] = "������-�����������",
	[58] = "����-��������",
	[59] = "���������-������",
	[60] = "������-������",
	[61] = "����-�����������",
	[62] = "����-��������",
	[63] = "����������-������",
	[64] = "������-������",
	[65] = "����������",
	[66] = "������ ����-������-�����������",
	[67] = "�������-������",
	[68] = "��������-������",
	[69] = "����������",
	[70] = "����-��������",
	[71] = "������ �������-������",
	[72] = "��������-��������",
	[73] = "��������-�������",
	[74] = "����-���������",
	[75] = "����� ������ ������",
	[76] = "������-����������",
	[77] = "������-�����������",
	[78] = "����-��������",
	[79] = "����-������",
	[80] = "����-��������",
	[81] = "������-������",
	[82] = "����-��������",
	[83] = "������-������",
	[84] = "����-�����������",
	[85] = "����-��������",
	[86] = "����-�������",
	[87] = "����-������",
	[88] = "�����-��������",
	[89] = "������-����������",
	[90] = "������-������",
	[91] = "��������-������",
	[92] = "����-������",
	[93] = "������",
	[94] = "����-������",
	[95] = "����-������",
	[96] = "������-������",
	[97] = "�������-������",
	[98] = "����-������",
	[99] = "������ ����-�����������",
	[100] = "�����������-������",
	[101] = "��������-������",
	[102] = "������-�����������",
	[103] = "������",
	[104] = "������-�����������",
	[105] = "��������-������",
	[106] = "������",
	[107] = "����������",
	[108] = "�����������-������",
	[109] = "��������-������",
	[110] = "������ ��������-������",
	[111] = "��������-��������",
	[112] = "��������-������",
	[113] = "����-�����������",
	[114] = "��������-�������",
	[115] = "����-��������",
	[116] = "����-������",
	[117] = "����-���������",
	[118] = "������-��������",
	[119] = "����������-�����������",
	[120] = "����������",
	[121] = "����-���������",
	[122] = "����-������",
	[123] = "����-�����������",
	[124] = "����-��������",
	[125] = "����-������",
	[126] = "��������",
	[127] = "�������",
	[128] = "�������",
	[129] = "������ ���������",
	[130] = "������",
	[131] = "����-�����������",
	[132] = "����-��������",
	[133] = "������� � ����� �������� �������",
	[134] = "����-������",
	[135] = "����-������",
	[136] = "������������",
	[137] = "��������� �������",
	[138] = "������ ������",
	[139] = "����������� ��������-������",
	[140] = "������-������",
	[141] = "����-������",
	[142] = "����������",
	[143] = "����-������ � ���������� ��������",
	[144] = "����-�����������",
	[145] = "������-�������",
	[146] = "��������-�����������",
	[147] = "����-�����������",
	[148] = "������ ����-��������-�������",
	[149] = "����� ����-�����������",
	[150] = "��������-�������",
	[151] = "�������",
	[152] = "����-�������",
	[153] = "������-��������",
	[154] = "������-������",
	[155] = "����-�������",
	[156] = "����-�����������",
	[157] = "�������",
	[158] = "����-�������",
	[159] = "����-�����������",
	[160] = "����-��������",
	[161] = "������-�����������",
	[162] = "����-�����������",
	[163] = "����-��������",
	[164] = "����-������",
	[165] = "������-�����������",
	[166] = "����-������",
	[167] = "����-����������",
	[168] = "����-������",
	[169] = "����-��������",
	[170] = "����-����������",
	[171] = "����-����������",
	[172] = "�������",
	[173] = "����-������",
	[174] = "������",
	[175] = "����-�����������",
	[176] = "����-����������",
	[177] = "����-�����������",
	[178] = "����-�������",
	[179] = "����-������",
	[180] = "������-������",
	[181] = "����-�������",
	[182] = "����-����������",
	[183] = "������-����������",
	[184] = "������-������",
	[185] = "�������",
	[186] = "����-�����������",
	[187] = "����-������",
	[188] = "����-�����������",
	[189] = "������-����������",
	[190] = "������-�������",
	[191] = "�������",
	[192] = "����-����������",
	[193] = "����-�����������",
	[194] = "����-�������",
	[195] = "����-�����������",
	[196] = "�������",
	[197] = "����-������",
	[198] = "����-�����������",
	[199] = "����-����������",
	[200] = "�������",
	[201] = "����-�����������",
	[202] = "������-�����������",
	[203] = "������-�����������",
	[204] = "�������",
	[205] = "����-������",
	[206] = "����-�������",
	[207] = "�������",
	[208] = "����-������",
	[209] = "����-�������",
	[210] = "�������",
	[211] = "����-������",
	[212] = "����-�������",
	[213] = "�������",
	[214] = "����-������",
	[215] = "����-�����������",
	[216] = "����-����������",
	[217] = "����-�����������",
	[218] = "����-������",
	[219] = "�������",
	[220] = "����-�������",
	[221] = "�������",
	[222] = "����-�����������",
	[223] = "�������",
	[224] = "����-������",
	[225] = "����-�������",
	[226] = "�������",
	[227] = "����-������",
	[228] = "����-�����������",
	[229] = "����-����������",
	[230] = "�������",
	[231] = "����-�����������",
	[232] = "����-������",
	[233] = "�������",
	[234] = "����-������",
	[235] = "����-�����������",
	[236] = "����-�������",
	[237] = "�������",
	[238] = "����-����������",
	[239] = "����-�����������",
	[240] = "����-�������",
	[241] = "����-������",
	[242] = "����-�����������",
	[243] = "����-������",
	[244] = "�������",
	[245] = "����-�������",
	[246] = "����-�����������",
	[247] = "����-������",
	[248] = "����-�������",
	[249] = "�������",
	[250] = "����-����������",
	[251] = "����-������",
	[252] = "�������",
	[253] = "����-�����������",
	[254] = "����-�������",
	[255] = "����-������"
}
local cache = {}
local plate = {
	carID = 0,
	number = "",
	type = "",
}
function plate.new(carID, number, type)
    o = {
		carID = carID or 0,
		number = number or "",
		type = type or "",
	}
    return o
end
------------------------------------------- MonetLoader --------------------------------------------------
function isMonetLoader() return MONET_VERSION ~= nil end
if isMonetLoader() then
	gta = ffi.load('GTASA') 
	ffi.cdef[[ void _Z12AND_OpenLinkPKc(const char* link); ]] -- ������� ��� �������� ������
end
if not settings.general.autofind_dpi then
	print('[Justice Helper] ���������� ����-������� �������...')
	if isMonetLoader() then
		settings.general.custom_dpi = MONET_DPI_SCALE
	else
		local base_width = 1366
		local base_height = 768
		local current_width, current_height = getScreenResolution()
		local width_scale = current_width / base_width
		local height_scale = current_height / base_height
		settings.general.custom_dpi = (width_scale + height_scale) / 2
	end
	settings.general.autofind_dpi = true
	print('[Justice Helper] ����������� ��������: ' .. settings.general.custom_dpi)
	save_settings()
end
---------------------------------------------- Mimgui -----------------------------------------------------
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')

local MainWindow = imgui.new.bool()
local checkboxone = imgui.new.bool(false)
local checkbox_accent_enable = imgui.new.bool(settings.general.accent_enable or false)
local checkbox_patrool_autodoklad =  imgui.new.bool(settings.general.auto_doklad_patrool or false)
local checkbox_autodoklad_damage =  imgui.new.bool(settings.general.auto_doklad_damage or false)
local checkbox_autodoklad_arrest =  imgui.new.bool(settings.general.auto_doklad_arrest or false)
local checkbox_automask =  imgui.new.bool(settings.general.auto_mask or false)
local checkbox_change_code_siren = imgui.new.bool(settings.general.auto_change_code_siren or false)
local checkbox_update_members = imgui.new.bool(settings.general.auto_update_members or false)
local checkbox_auto_time = imgui.new.bool(settings.general.auto_time or false)
local checkbox_update_wanteds = imgui.new.bool(settings.general.auto_update_wanteds or false)
local checkbox_autodocumentation = imgui.new.bool(settings.general.auto_documentation or false)
local checkbox_notify_payday = imgui.new.bool(settings.general.auto_notify_payday or false)
local checkbox_auto_clicker = imgui.new.bool(settings.general.auto_clicker_situation or false)
local checkbox_auto_accept_docs = imgui.new.bool(settings.general.auto_accept_docs or false)
local checkbox_awanted = imgui.new.bool(settings.general.auto_find_wanteds or false)
local checkbox_mobile_stop_button = imgui.new.bool(settings.general.mobile_stop_button or false)
local checkbox_mobile_fastmenu_button = imgui.new.bool(settings.general.mobile_fastmenu_button or false)
local checkbox_mobile_taser_button = imgui.new.bool(settings.general.use_taser_menu or false)
local checkbox_mobile_meg_button = imgui.new.bool(settings.general.mobile_meg_button or false)
local input_accent = imgui.new.char[256](u8(settings.player_info.accent))
local input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
local input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
local theme = imgui.new.int(0)
slider_dpi = imgui.new.float(tonumber(settings.general.custom_dpi) or 1)

local DeportamentWindow = imgui.new.bool()
local input_dep_fm = imgui.new.char[32](u8(settings.deportament.dep_fm))
local input_dep_text = imgui.new.char[256]()
local input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
local input_dep_tag2 = imgui.new.char[32](u8(settings.deportament.dep_tag2))
local input_dep_new_tag = imgui.new.char[32]()

local MembersWindow = imgui.new.bool()
local members = {}
local members_new = {}
local members_check = false
local members_fraction = ''
local update_members_check = false

local WantedWindow = imgui.new.bool()
local updwanteds_time = 0
local updwanteds_last_time = 0
local wanted = {}
local wanted_new = {}
local check_wanted = false
local update_wanted_check = false
local search_awanted = false

local GiveRankMenu = imgui.new.bool()
local giverank = imgui.new.int(5)

local SobesMenu = imgui.new.bool()

local FastPieMenu = imgui.new.bool()

local PatroolMenu = imgui.new.bool()
local PatroolInfoMenu = imgui.new.bool()
local patrool_start_time = 0
local patrool_current_time = 0
local patrool_time = 0
local patrool_code = 'CODE 4'
local patrool_mark = 'ADAM'
local patrool_active = false
local ComboPatroolMark = imgui.new.int(0)
local combo_patrool_mark_list = {'ADAM', 'LINCOLN', 'MARY', 'HENRY', 'AIR', 'ASD', 'CHARLIE', 'ROBERT', 'SUPERVISOR', 'DAVID', 'EDWARD', 'NORA'}
local ImItemsPatroolMark = imgui.new['const char*'][#combo_patrool_mark_list](combo_patrool_mark_list)
local ComboPatroolCode = imgui.new.int(5)
local combo_patrool_code_list = {'CODE 0', 'CODE 1', 'CODE 2', 'CODE 2 HIGHT', 'CODE 3', 'CODE 4', 'CODE 4 ADAM', 'CODE 5', 'CODE 6', 'CODE 7', 'CODE 30', 'CODE 30 RINGER', 'CODE 37', 'CODE TOM'}
local ImItemsPatroolCode = imgui.new['const char*'][#combo_patrool_code_list](combo_patrool_code_list)

local SumMenuWindow = imgui.new.bool()
local input_sum = imgui.new.char[128]()
local form_su = ''

local TsmMenuWindow = imgui.new.bool()
local input_tsm = imgui.new.char[128]()

local CommandStopWindow = imgui.new.bool()
local CommandPauseWindow = imgui.new.bool()

local LeaderFastMenu = imgui.new.bool()
local FastMenu = imgui.new.bool()
local FastPieMenu = imgui.new.bool()
local FastMenuButton = imgui.new.bool()
local FastMenuPlayers = imgui.new.bool()
local MegafonWindow = imgui.new.bool()

local RPWeaponWindow = imgui.new.bool()
local ComboTags2 = imgui.new.int()
local item_list2 = {u8'�����', u8'������', u8'����', u8'������'}
local ImItems2 = imgui.new['const char*'][#item_list2](item_list2)
local input_weapon_name = imgui.new.char[256]()
local input_weapon_name_search = imgui.new.char[256]()

local NoteWindow = imgui.new.bool()
local show_note_name = nil
local show_note_text = nil

local InformationWindow = imgui.new.bool()

local TaserWindow = imgui.new.bool()

local ArmHealWindow = imgui.new.bool()

local UpdateWindow = imgui.new.bool()
local updateUrl = ""
local updateVer = ""
local updateInfoText = ""
local need_update_helper = false
local download_helper = false
local download_smartuk = false
local download_smartpdd = false
local download_arzvehicles = false

local BinderWindow = imgui.new.bool()
local waiting_slider = imgui.new.float(0)
local ComboTags = imgui.new.int()
local item_list = {u8'��� ����������', u8'{arg} - ��������� ����� ��������', u8'{arg_id} - ��������� ������ �������� ID ������', u8'{arg_id} {arg2} - ��������� 2 ���������: ID ������ � ����� ��������', u8'{arg_id} {arg2} {arg3} - ��������� 3 ���������: ID ������, ���� �����, � ����� ��������'}
local ImItems = imgui.new['const char*'][#item_list](item_list)

local binder_data = {change_waiting = nil, change_cmd = nil, change_text = nil, change_arg = nil, change_bind = nil, change_in_fastmenu = false, create_command_9_10 = false, input_description = nil}

local tagReplacements = {
	my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
    my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
    my_rp_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_',' ') end,
    my_doklad_nick = function() 
		local nick
		if isMonetLoader() then
			nick = ReverseTranslateNick(settings.player_info.name_surname)
		else
			nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		end
		if nick:find('(.+)%_(.+)') then
			local name, surname = nick:match('(.+)%_(.+)')
			return name:sub(1, 1)  .. '.' .. surname
		else
			return nick
		end
    end,
	my_ru_nick = function() return TranslateNick(settings.player_info.name_surname) end,
	fraction_rank_number = function() return settings.player_info.fraction_rank_number end,
	fraction_rank = function() return settings.player_info.fraction_rank end,
	fraction_tag = function() return settings.player_info.fraction_tag end,
	fraction = function() return settings.player_info.fraction end,
	sex = function() 
		if settings.player_info.sex == '�������' then
			local temp = '�'
			return temp
		else
			return ''
		end
	end,
	get_time = function ()
		return os.date("%H:%M:%S")
	end,
	get_rank = function ()
		return giverank[0]
	end,
	get_square = function ()
		return kvadrat()
	end,
	get_area = function ()
		local x,y,z = getCharCoordinates(PLAYER_PED)
		return calculateZoneRu(x,y,z)
	end,
	get_city = function ()
		local city = {
			[0] = "��� ������",
			[1] = "��� ������",
			[2] = "��� ������",
			[3] = "��� ��������"
		}
		return city[getCityPlayerIsIn(PLAYER_PED)]
	end,
	get_storecar_model = function ()
		local closest_car = nil
		local closest_distance = 75
		local my_pos = {getCharCoordinates(PLAYER_PED)}
		local my_car
		if isCharInAnyCar(PLAYER_PED) then
			my_car = storeCarCharIsInNoSave(PLAYER_PED)
		end
		for _, vehicle in ipairs(getAllVehicles()) do
			if doesCharExist(getDriverOfCar(vehicle)) and vehicle ~= my_car then
				local vehicle_pos = {getCarCoordinates(vehicle)}
				local distance = getDistanceBetweenCoords3d(my_pos[1], my_pos[2], my_pos[3], vehicle_pos[1], vehicle_pos[2], vehicle_pos[3])
				if distance < closest_distance and vehicle ~= my_car then
					--sampAddChatMessage(math.floor(distance),-1)
					closest_distance = distance
					closest_car = vehicle
				end
				--sampAddChatMessage(select(2, sampGetPlayerIdByCharHandle(getDriverOfCar(vehicle))), 0x009EFF)
			end
		end
		if closest_car then
			local clr1, clr2 = getCarColours(closest_car)
			local CarColorName
			if clr1 == clr2 then
				CarColorName = colorNames[clr1] .. " �����" or ""
			else
				CarColorName = colorNames[clr1] .. '-' .. colorNames[clr2] .. " �����" or ""
			end
			function getVehPlateNumberByCarHandle(car)
				for shit, plate in pairs(cache) do 
					result, veh = sampGetCarHandleBySampVehicleId(plate.carID)
					if result and veh == car then
						return ' (' .. plate.number .. ') '
					end
				end
				return ' '
				
			end
			return "" .. getNameOfARZVehicleModel(getCarModel(closest_car)) .. getVehPlateNumberByCarHandle(closest_car) .. CarColorName
		else
			sampAddChatMessage("[Justice Helper] {ffffff}�� ������� �������� ������ ���������� �/c � ���������!", 0x009EFF)
			return ' ������������� ��������'
		end
	end,
	get_form_su = function ()
		return form_su
	end,
	get_patrool_time = function ()
		local hours = math.floor(patrool_time / 3600)
		local minutes = math.floor(( patrool_time % 3600) / 60)
		local secs = patrool_time % 60
		if hours > 0 then
			return string.format("%02d:%02d:%02d", hours, minutes, secs)
		else
			return string.format("%02d:%02d", minutes, secs)
		end
	end,
	get_patrool_code = function ()
		return patrool_code
	end,
	get_patrool_mark = function ()
		return patrool_mark .. '-' .. select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
	end,
	get_car_units = function ()
		if isCharInAnyCar(PLAYER_PED) then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			local success, passengers = getNumberOfPassengers(car)
			if isMonetLoader() and success and passengers == nil then
				passengers = success
			end
			if success and passengers and tonumber(passengers) > 0 then
				local my_passengers = {}
				for k, v in ipairs(getAllChars()) do
					local res, id = sampGetPlayerIdByCharHandle(v)
					if res and id ~= select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
						if isCharInAnyCar(v) then
							if car == storeCarCharIsInNoSave(v) then
								table.insert(my_passengers, id)
							end
						end
					end
				end
				if #my_passengers ~= 0 then
					local units = ''
					for k, idd in ipairs(my_passengers) do
						local nickname = sampGetPlayerNickname(idd)
						local first_letter = nickname:sub(1, 1)
						local last_name = nickname:match(".*_(.*)")
						if last_name then
							units = units .. first_letter .. "." .. last_name .. ' '
						else
							units = units .. nickname .. ' ' -- � ������, ���� ��� �������������
						end
					end
					return units
				else
					--sampAddChatMessage('[Justice Helper] � ����� ���� ���� ����� ����������12345678!', -1)
					return '����'
				end
			else
				return '����'
			end
		else
			--sampAddChatMessage('[Justice Helper] �� �� ���������� � ����, ���������� �������� ����� ����������!', -1)
			return '����'
		end
	end,
	switchCarSiren = function ()
		if isCharInAnyCar(PLAYER_PED) then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			if getDriverOfCar(car) == PLAYER_PED then
				switchCarSiren(car, not isCarSirenOn(car))
				return '/me ' .. ( isCarSirenOn(car) and '��������' or '���������') .. ' ������� � ���� ������������ ��������'
			else
				sampAddChatMessage('[Justice Helper] {ffffff}�� �� �� ����!', 0x009EFF)
				return (isCarSirenOn(car) and '�������' or '������') .. ' �������!'
			end
		else
			sampAddChatMessage('[Justice Helper] {ffffff}�� �� � ����������!', 0x009EFF)
			return "���"
		end
	end
}
local binder_tags_text = [[
{my_id} - ��� ID
{my_nick} - ��� ������� 
{my_rp_nick} - ��� ������� ��� _
{my_ru_nick} - ���� ��� � �������
{my_doklad_nick} - ������ ����� ������ ����� � �������

{fraction} - ���� �������
{fraction_rank} - ���� ����������� ���������
{fraction_tag} - ��� ����� �������

{sex} - ��������� ����� "�" ���� � ������� ������ ������� ���

{get_time} - �������� ������� �����
{get_city} - �������� ������� �����
{get_square} - �������� ������� �������
{get_area} - �������� ������� �����
{get_storecar_model} - �������� ������ ���������� � ��� ���� � ���������

{get_nick({arg_id})} - �������� ������� �� ��������� ID ������
{get_rp_nick({arg_id})} - �������� ������� ��� ������� _ �� ��������� ID ������
{get_ru_nick({arg_id})} - �������� ������� �� �������� �� ��������� ID ������ 

{pause} - ��������� ��������� ������� �� ����� � ������� ��������]]

-------------------------------------------- MoonMonet ----------------------------------------------------

local monet_no_errors, moon_monet = pcall(require, 'MoonMonet') -- ��������� ���������� ����������

local message_color = 0x009EFF
local message_color_hex = '{009EFF}'

if settings.general.moonmonet_theme_enable and monet_no_errors then
	function rgbToHex(rgb)
		local r = bit.band(bit.rshift(rgb, 16), 0xFF)
		local g = bit.band(bit.rshift(rgb, 8), 0xFF)
		local b = bit.band(rgb, 0xFF)
		local hex = string.format("%02X%02X%02X", r, g, b)
		return hex
	end
	message_color = settings.general.moonmonet_theme_color
	message_color_hex = '{' ..  rgbToHex(settings.general.moonmonet_theme_color) .. '}'
   
	theme[0] = 1
else
	theme[0] = 0
end
local tmp = imgui.ColorConvertU32ToFloat4(settings.general.moonmonet_theme_color)
local mmcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)

------------------------------------------- Mimgui Hotkey  -----------------------------------------------------
local hotkeys = {}
if not isMonetLoader() then
	hotkey_no_errors, hotkey = pcall(require, 'mimgui_hotkeys')
	if hotkey_no_errors then
		hotkey.Text.NoKey = u8'< click and select keys >'
		hotkey.Text.WaitForKey = u8'< wait keys >'
		MainMenuHotKey = hotkey.RegisterHotKey('Open MainMenu', false, decodeJson(settings.general.bind_mainmenu), function()
			if settings.general.use_binds then 
				if not MainWindow[0] then
					MainWindow[0] = true
				end
			end
		end)
		FastMenuHotKey = hotkey.RegisterHotKey('Open FastMenu', false, decodeJson(settings.general.bind_fastmenu), function() 
			if settings.general.use_binds then 
				local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
				if valid and doesCharExist(ped) then
					local result, id = sampGetPlayerIdByCharHandle(ped)
					if result and id ~= -1 and not LeaderFastMenu[0] then
						show_fast_menu(id)
					end
				end
			end
		end)
		LeaderFastMenuHotKey = hotkey.RegisterHotKey('Open LeaderFastMenu', false, decodeJson(settings.general.bind_leader_fastmenu), function() 
			if settings.general.use_binds then 
				if tonumber(settings.player_info.fraction_rank_number) >= 1 then 
					local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
					if valid and doesCharExist(ped) then
						local result, id = sampGetPlayerIdByCharHandle(ped)
						if result and id ~= -1 and not FastMenu[0] then
							show_leader_fast_menu(id)
						end
					end
				end
			end
		end)
		CommandStopHotKey = hotkey.RegisterHotKey('Stop Command', false, decodeJson(settings.general.bind_command_stop), function() 
			if settings.general.use_binds then 
				sampProcessChatInput('/stop')
			end
		end)

		function getNameKeysFrom(keys)
			local keys = decodeJson(keys)
			local keysStr = {}
			for _, keyId in ipairs(keys) do
				local keyName = require('vkeys').id_to_name(keyId) or ''
				table.insert(keysStr, keyName)
			end
			return tostring(table.concat(keysStr, ' + '))
		end

		function loadHotkeys()
			for _, command in ipairs(commands.commands) do
				updateHotkeyForCommand(command)
			end
			for _, command in ipairs(commands.commands_manage) do
				updateHotkeyForCommand(command)
			end
		end
		
		function updateHotkeyForCommand(command)
			local hotkeyName = command.cmd .. "HotKey"
			if hotkeys[hotkeyName] then
				hotkey.RemoveHotKey(hotkeyName)
			end
			if command.arg == '' and command.bind ~= nil and command.bind ~= '{}' and command.bind ~= '[]' then
				hotkeys[hotkeyName] = hotkey.RegisterHotKey(hotkeyName, false, decodeJson(command.bind), function()
					if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
					
					else
						sampProcessChatInput('/' .. command.cmd)
					end
				end)
				print('[Justice Helper] ������ ������ ��� ������� /' .. command.cmd .. ' �� ������� ' .. getNameKeysFrom(command.bind))
				sampAddChatMessage('[Justice Helper] {ffffff}������ ������ ��� ������� ' .. message_color_hex .. '/' .. command.cmd .. ' {ffffff}�� ������� '  .. message_color_hex .. getNameKeysFrom(command.bind), message_color)
			end
		end

		addEventHandler('onWindowMessage', function(msg, key, lparam)
			if msg == 641 or msg == 642 or lparam == -1073741809 then  hotkey.ActiveKeys = {} end
			if msg == 0x0005 then hotkey.ActiveKeys = {} end
		end)
	end
end
------------------------------------------------- Other --------------------------------------------------------
local PlayerID = nil
local player_id = nil
local check_stats = false
local anti_flood_auto_uval = false
local spawncar_bool = false

local vc_vize_bool = false
local vc_vize_player_id = nil

local godeath_player_id = nil
local godeath_locate = ''
local godeath_city = ''

local clicked = false

local awanted = false

local message1
local message2
local message3

local isActiveCommand = false

local debug_mode = false

local command_stop = false
local command_pause = false

local auto_uval_checker = false

local platoon_check = false

local enemy = {}

local afind = false

local InfraredVision = false
local NightVision = false

local isRightMousePressed = false
local lastProcessedWeapon = nil -- ��� ������������ ��� ������������� ������
------------------------------------------- Main -----------------------------------------------------
function welcome_message()
	if not sampIsLocalPlayerSpawned() then 
		sampAddChatMessage('[Justice Helper] {ffffff}������������� ������� ������ �������!',message_color)
		sampAddChatMessage('[Justice Helper] {ffffff}��� ������ �������� ������� ������� ������������ (������� �� ������)',message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end
	sampAddChatMessage('[Justice Helper] {ffffff}�������� ������� ������ �������!', message_color)
	print('[Justice Helper] �������� ������� ������ �������!')
	show_arz_notify('info', 'Justice Helper', "�������� ������� ������ �������!", 3000)
	if isMonetLoader() or settings.general.bind_mainmenu == nil or not settings.general.use_binds then	
		sampAddChatMessage('[Justice Helper] {ffffff}���� ������� ���� ������� ������� ������� ' .. message_color_hex .. '/jh', message_color)
	elseif hotkey_no_errors and settings.general.bind_mainmenu and settings.general.use_binds then
		sampAddChatMessage('[Justice Helper] {ffffff}���� ������� ���� ������� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_mainmenu) .. ' {ffffff}��� ������� ������� ' .. message_color_hex .. '/jh', message_color)
	else
		sampAddChatMessage('[Justice Helper] {ffffff}���� ������� ���� ������� ������� ������� ' .. message_color_hex .. '/jh', message_color)
	end
end
function registerCommandsFrom(array)
	for _, command in ipairs(array) do
		
		if command.enable then
			register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
		end
	end
end
function register_command(chat_cmd, cmd_arg, cmd_text, cmd_waiting)
	sampRegisterChatCommand(chat_cmd, function(arg)
		if not isActiveCommand then
			if command_stop then
				command_stop = false
			end
			local arg_check = false
			local modifiedText = cmd_text
			if cmd_arg == '{arg}' then
				if arg and arg ~= '' then
					modifiedText = modifiedText:gsub('{arg}', arg or "")
					arg_check = true
				else
					sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [��������]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id}' then
				if isParamSampID(arg) then
					arg = tonumber(arg)
					modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg) or "")
					modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg):gsub('_',' ') or "")
					modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg)) or "")
					modifiedText = modifiedText:gsub('%{arg_id%}', arg or "")
					arg_check = true
				else
					sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id} {arg2}' then
				if arg and arg ~= '' then
					local arg_id, arg2 = arg:match('(%d+) (.+)')
					if isParamSampID(arg_id) and arg2 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
						arg_check = true
					else
						sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������]', message_color)
					play_error_sound()
				end
            elseif cmd_arg == '{arg_id} {arg2} {arg3}' then
				if arg and arg ~= '' then
					local arg_id, arg2, arg3 = arg:match('(%d+) (%d) (.+)')
					if isParamSampID(arg_id) and arg2 and arg3 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
                        modifiedText = modifiedText:gsub('%{arg3%}', arg3 or "")
						arg_check = true
					else
						sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������] [��������]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������] [��������]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '' then
				arg_check = true
			end
			if arg_check then
				lua_thread.create(function()
					isActiveCommand = true
					command_pause = false
					if modifiedText:find('&.+&') then
						if isMonetLoader() and settings.general.mobile_stop_button then
							sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
						end
					end
					local lines = {}
					for line in string.gmatch(modifiedText, "[^&]+") do
						table.insert(lines, line)
					end
					for line_index, line in ipairs(lines) do
						if command_stop then 
							command_stop = false 
							isActiveCommand = false
							if isMonetLoader() and settings.general.mobile_stop_button then
								CommandStopWindow[0] = false
							end
							sampAddChatMessage('[Justice Helper] {ffffff}��������� ������� /' .. chat_cmd .. " ������� �����������!", message_color) 
							break	
						else
							for tag, replacement in pairs(tagReplacements) do
								if line:find("{" .. tag .. "}") then
									local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
									if success then
										line = result
									end
								end
							end
							if line == '{lmenu_vc_vize}' then
								if cmd_arg == '{arg_id}' then
									vc_vize_player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										vc_vize_player_id = tonumber(arg_id)
									end
								end
								vc_vize_bool = true
								sampSendChat("/lmenu")
								break
							elseif line == '{show_rank_menu}' then
								if cmd_arg == '{arg_id}' then
									player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										player_id = arg_id
									end
								end
								GiveRankMenu[0] = true
								break
							elseif line == "{pause}" then
								sampAddChatMessage('[Justice Helper] {ffffff}������� /' .. chat_cmd .. ' ���������� �� �����!', message_color)
								command_pause = true
								CommandPauseWindow[0] = true
								while command_pause do
									wait(0)
								end
								if not command_stop then
									sampAddChatMessage('[Justice Helper] {ffffff}��������� ��������� ������� /' .. chat_cmd, message_color)	
								end					
							else
								if line_index ~= 1 then wait(cmd_waiting * 1000) end
								if not command_stop then
									sampSendChat(line)
								else
									command_stop = false 
									isActiveCommand = false
									if isMonetLoader() and settings.general.mobile_stop_button then
										CommandStopWindow[0] = false
									end
									sampAddChatMessage('[Justice Helper] {ffffff}��������� ������� /' .. chat_cmd .. " ������� �����������!", message_color) 	
									break
								end
							end
						end
						
					end
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
					end
				end)
			end
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
end
function find_and_use_command(cmd, cmd_arg)
	local check = false
	for _, command in ipairs(commands.commands) do
		if command.enable and command.text:find(cmd) then
			check = true
			sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
			return
		end
	end
	if not check then
		for _, command in ipairs(commands.commands_manage) do
			if command.enable and command.text:find(cmd) then
				check = true
				sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
				return
			end
		end
	end
	if not check then
		sampAddChatMessage('[Justice Helper] {ffffff}������, �� ���� ����� ���� ��� ���������� ���� �������!', message_color)
		play_error_sound()
		return
	end
end
function initialize_commands()
	sampRegisterChatCommand("jh", function() MainWindow[0] = not MainWindow[0] end)
	sampRegisterChatCommand("jm", show_fast_menu)
	sampRegisterChatCommand("stop", function() 
		if isActiveCommand then 
			command_stop = true 
		else 
			sampAddChatMessage('[Justice Helper] {ffffff}� ������ ������ ���� ������� �������� �������/���������!', message_color) 
		end
	end)
	sampRegisterChatCommand("sum", function(arg) 
		if not isActiveCommand then
			if isParamSampID(arg) then
				if #smart_uk ~= 0 then
					player_id = tonumber(arg)
					SumMenuWindow[0] = true 
				else
					sampAddChatMessage('[Justice Helper] {ffffff}������� ���������/�������������� ����� ������ � /jh', message_color)
					play_error_sound()
				end
			else
				sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/sum [ID ������]', message_color)
				play_error_sound()
			end	
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("tsm", function(arg) 
		if not isActiveCommand then
			if isParamSampID(arg) then
				if #smart_pdd ~= 0 then
					player_id = tonumber(arg)
					TsmMenuWindow[0] = true 
				else
					sampAddChatMessage('[Justice Helper] {ffffff}������� ���������/�������������� ����� ������ � /jh', message_color)
					play_error_sound()
				end
			else
				sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/tsm [ID ������]', message_color)
				play_error_sound()
			end	
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("sob", function(arg)
		if not isActiveCommand then
			if isParamSampID(arg) then
				player_id = tonumber(arg)
				SobesMenu[0] = not SobesMenu[0]
			else
				sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/sob [ID ������]', message_color)
				play_error_sound()
			end	
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("pnv", function(arg)
		if not isActiveCommand then
			NightVision = not NightVision
			if NightVision then
				sampSendChat('/me ������ �� ������� ���� ������� ������� � �������� ��')
			else
				sampSendChat('/me ������� � ���� ���� ������� ������� � ������� �� � ������')
			end
			setNightVision(NightVision)	
			InfraredVision = false
			setInfraredVision(InfraredVision)	
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("irv", function(arg)
		if not isActiveCommand then
			InfraredVision = not InfraredVision
			setInfraredVision(InfraredVision)	
			NightVision = false
			setNightVision(NightVision)	
			if InfraredVision then
				sampSendChat('/me ������ �� ������� ����������� ���� � �������� ��')
			else
				sampSendChat('/me ������� � ���� ����������� ���� � ������� �� � ������')
			end
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("awanted", function() 
		for i = 1, 10, 1 do
			sampAddChatMessage('[Justice Helper] {ffffff}������ ������� �������� ������ � ������� ������ �������! �������� � MTG MODS', message_color)
		end
	end)
	sampRegisterChatCommand("wanted", function(arg)
		sampSendChat('/wanted ' .. arg)
		sampAddChatMessage('[Justice Helper] {ffffff}����� ����������� /wanteds ��� ���������������� ����� �������!', message_color)
	end)
	sampRegisterChatCommand("meg", function ()
		MegafonWindow[0] = not MegafonWindow[0]
	end)
	sampRegisterChatCommand("afind", function (arg)
		for i = 1, 10, 1 do
			sampAddChatMessage('[Justice Helper] {ffffff}������ ������� �������� ������ � ������� ������ �������! �������� � MTG MODS', message_color)
		end
	end)
	sampRegisterChatCommand("wanteds", function(arg)
		if WantedWindow[0] then
			WantedWindow[0] = false
			update_wanted_check = false
			sampAddChatMessage('[Justice Helper] {ffffff}���� ������ ������������ �������!', message_color)
		elseif not isActiveCommand then
			lua_thread.create(function()
				sampAddChatMessage('[Justice Helper] {ffffff}������� ������������ ����� /wanted, ��������...', message_color)
				show_arz_notify('info', 'Justice Helper', "������������ /wanted...", 2500)
				wanted_new = {}
				check_wanted = true
				local max_lvl = (settings.player_info.fraction_tag == '���' or settings.player_info.fraction_tag == 'FBI') and 7 or 6
				for i = max_lvl, 1, -1 do
					sampSendChat('/wanted ' .. i)
					wait(285)
				end
				check_wanted = false
				if #wanted_new == 0 then
					sampAddChatMessage('[Justice Helper] {ffffff}������ �� ������� ���� ������� � ��������!', message_color)
				else
					sampAddChatMessage('[Justice Helper] {ffffff}������������ ����� /wanted ��������, ������� ������������: ' .. message_color_hex .. #wanted_new, message_color)
					wanted = wanted_new
					updwanteds_time = 0
					updwanteds_last_time = os.time()
					update_wanted_check = true
					WantedWindow[0] = true
					if settings.general.auto_find_wanteds and awanted then
						search_awanted = true
						sampAddChatMessage('[Justice Helper - AWANTED] {ffffff}�� ������ ������� ��� ���� � ������ /awanted', message_color)
					end
				end
			end)
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("debug", function() debug_mode = not debug_mode sampAddChatMessage('[JH DEBUG] {ffffff}������������ ������ ' .. (debug_mode and '��������!' or '���������!'), message_color) end)
	sampRegisterChatCommand("maska", function() 
		if not isActiveCommand then
			isActiveCommand = true
			if isMonetLoader() and settings.general.mobile_stop_button then
				sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
				CommandStopWindow[0] = true
			elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
				sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
			else
				sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
			end
			if sampGetPlayerColor(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) == 23486046 then
				lua_thread.create(function()
					if not ifCommandPause() then sampSendChat('/do ��������� �� ������.') end
					wait(1500)
					if not ifCommandPause() then sampSendChat('/me ��������� ��������� � ������ � ���������� � � ����������� �����') end
					wait(1500)
					if not ifCommandPause() then sampSendChat('/mask') end
					wait(1500)
					if not ifCommandPause() then sampSendChat('/do ��������� ����������� � ������������ �����.') end
					isActiveCommand = false
				end)
			else
				lua_thread.create(function()
					if not ifCommandPause() then sampSendChat('/do ��������� ����������� � ������������ �����.') end
					wait(1500)
					if not ifCommandPause() then sampSendChat('/me ������ ��������� � ���������� � ���� �� ������') end
					wait(1500)
					if not ifCommandPause() then sampSendChat('/mask') end
					wait(1500)
					if not ifCommandPause() then sampSendChat('/do ��������� �� ������.') end
					isActiveCommand = false
				end)
			end
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("patrool", function(arg)
		if not isActiveCommand then
			PatroolMenu[0] = not PatroolMenu[0]
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("mb", function(arg)
		if not isActiveCommand then
			if MembersWindow[0] then
				MembersWindow[0] = false
			else
				members_new = {} 
				members_check = true 
				sampSendChat("/members")
			end
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("dep", function(arg)
		if not isActiveCommand then
			DeportamentWindow[0] = not DeportamentWindow[0]
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	-- ����������� ���� ������ ������� ���� � json
	registerCommandsFrom(commands.commands)
	if tonumber(settings.player_info.fraction_rank_number) >= 1 then 
		sampRegisterChatCommand("jlm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not isActiveCommand then
				lua_thread.create(function()
					isActiveCommand = true
					if isMonetLoader() and settings.general.mobile_stop_button then
						sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
						CommandStopWindow[0] = true
					elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
						sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
					else
						sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
					end
					sampSendChat("/rb ��������! ����� 15 ������ ����� ����� ���������� �����������.")
					wait(1500)
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Justice Helper] {ffffff}��������� ������� /spcar ������� �����������!', message_color) 
						return
					end
					sampSendChat("/rb ������� ���������, ����� �� ����� ���������.")
					wait(13500)	
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Justice Helper] {ffffff}��������� ������� /spcar ������� �����������!', message_color) 
						return
					end
					spawncar_bool = true
					sampSendChat("/lmenu")
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
					end
				end)
			else
				sampAddChatMessage('[Justice Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			end
		end)
		-- ����������� ���� ������ ������� ���� � json ��� 9/10
		registerCommandsFrom(commands.commands_manage) 
	end
end
local russian_characters = {
    [168] = '�', [184] = '�', [192] = '�', [193] = '�', [194] = '�', [195] = '�', [196] = '�', [197] = '�', [198] = '�', [199] = '�', [200] = '�', [201] = '�', [202] = '�', [203] = '�', [204] = '�', [205] = '�', [206] = '�', [207] = '�', [208] = '�', [209] = '�', [210] = '�', [211] = '�', [212] = '�', [213] = '�', [214] = '�', [215] = '�', [216] = '�', [217] = '�', [218] = '�', [219] = '�', [220] = '�', [221] = '�', [222] = '�', [223] = '�', [224] = '�', [225] = '�', [226] = '�', [227] = '�', [228] = '�', [229] = '�', [230] = '�', [231] = '�', [232] = '�', [233] = '�', [234] = '�', [235] = '�', [236] = '�', [237] = '�', [238] = '�', [239] = '�', [240] = '�', [241] = '�', [242] = '�', [243] = '�', [244] = '�', [245] = '�', [246] = '�', [247] = '�', [248] = '�', [249] = '�', [250] = '�', [251] = '�', [252] = '�', [253] = '�', [254] = '�', [255] = '�',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then -- �
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower russian characters
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then -- �
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function TranslateNick(name)
	if name:match('%a+') then
        for k, v in pairs({['ph'] = '�',['Ph'] = '�',['Ch'] = '�',['ch'] = '�',['Th'] = '�',['th'] = '�',['Sh'] = '�',['sh'] = '�', ['ea'] = '�',['Ae'] = '�',['ae'] = '�',['size'] = '����',['Jj'] = '��������',['Whi'] = '���',['lack'] = '���',['whi'] = '���',['Ck'] = '�',['ck'] = '�',['Kh'] = '�',['kh'] = '�',['hn'] = '�',['Hen'] = '���',['Zh'] = '�',['zh'] = '�',['Yu'] = '�',['yu'] = '�',['Yo'] = '�',['yo'] = '�',['Cz'] = '�',['cz'] = '�', ['ia'] = '�', ['ea'] = '�',['Ya'] = '�', ['ya'] = '�', ['ove'] = '��',['ay'] = '��', ['rise'] = '����',['oo'] = '�', ['Oo'] = '�', ['Ee'] = '�', ['ee'] = '�', ['Un'] = '��', ['un'] = '��', ['Ci'] = '��', ['ci'] = '��', ['yse'] = '��', ['cate'] = '����', ['eow'] = '��', ['rown'] = '����', ['yev'] = '���', ['Babe'] = '�����', ['Jason'] = '�������', ['liy'] = '���', ['ane'] = '���', ['ame'] = '���'}) do
            name = name:gsub(k, v) 
        end
		for k, v in pairs({['B'] = '�',['Z'] = '�',['T'] = '�',['Y'] = '�',['P'] = '�',['J'] = '��',['X'] = '��',['G'] = '�',['V'] = '�',['H'] = '�',['N'] = '�',['E'] = '�',['I'] = '�',['D'] = '�',['O'] = '�',['K'] = '�',['F'] = '�',['y`'] = '�',['e`'] = '�',['A'] = '�',['C'] = '�',['L'] = '�',['M'] = '�',['W'] = '�',['Q'] = '�',['U'] = '�',['R'] = '�',['S'] = '�',['zm'] = '���',['h'] = '�',['q'] = '�',['y'] = '�',['a'] = '�',['w'] = '�',['b'] = '�',['v'] = '�',['g'] = '�',['d'] = '�',['e'] = '�',['z'] = '�',['i'] = '�',['j'] = '�',['k'] = '�',['l'] = '�',['m'] = '�',['n'] = '�',['o'] = '�',['p'] = '�',['r'] = '�',['s'] = '�',['t'] = '�',['u'] = '�',['f'] = '�',['x'] = 'x',['c'] = '�',['``'] = '�',['`'] = '�',['_'] = ' '}) do
            name = name:gsub(k, v) 
        end
        return name
    end
	return name
end
function ReverseTranslateNick(name)
    local translit_table = {
        ['�'] = 'f', ['�'] = 'F', ['�'] = 'ch', ['�'] = 'Ch',
        ['�'] = 't', ['�'] = 'T', ['�'] = 'sh', ['�'] = 'Sh',
        ['�'] = 'i', ['�'] = 'E', ['�'] = 'e', ['�'] = 's',
        ['�'] = 'zh', ['�'] = 'Zh', ['�'] = 'yu', ['�'] = 'Yu',
        ['�'] = 'yo', ['�'] = 'Yo', ['�'] = 'ts', ['�'] = 'Ts',
        ['�'] = 'ya', ['�'] = 'Ya', ['��'] = 'ov', ['��'] = 'ey',
        ['�'] = 'u', ['�'] = 'U', ['�'] = 'I', ['��'] = 'an',
        ['��'] = 'tsi', ['��'] = 'uz', ['����'] = 'kate', ['��'] = 'yau',
        ['����'] = 'rown', ['���'] = 'uev', ['�����'] = 'Baby',
        ['�������'] = 'Jason', ['���'] = 'liy', ['���'] = 'ein', ['���'] = 'ame'
    }
    
    for k, v in pairs(translit_table) do
        name = name:gsub(k, v)
    end
    
    local char_table = {
        ['�'] = 'A', ['�'] = 'B', ['�'] = 'V', ['�'] = 'G', ['�'] = 'D',
        ['�'] = 'E', ['�'] = 'Yo', ['�'] = 'Zh', ['�'] = 'Z', ['�'] = 'I',
        ['�'] = 'Y', ['�'] = 'K', ['�'] = 'L', ['�'] = 'M', ['�'] = 'N',
        ['�'] = 'O', ['�'] = 'P', ['�'] = 'R', ['�'] = 'S', ['�'] = 'T',
        ['�'] = 'U', ['�'] = 'F', ['�'] = 'H', ['�'] = 'Ts', ['�'] = 'Ch',
        ['�'] = 'Sh', ['�'] = 'Sch', ['�'] = '', ['�'] = 'Y', ['�'] = '',
        ['�'] = 'E', ['�'] = 'Yu', ['�'] = 'Ya',
        ['�'] = 'a', ['�'] = 'b', ['�'] = 'v', ['�'] = 'g', ['�'] = 'd',
        ['�'] = 'e', ['�'] = 'yo', ['�'] = 'zh', ['�'] = 'z', ['�'] = 'i',
        ['�'] = 'y', ['�'] = 'k', ['�'] = 'l', ['�'] = 'm', ['�'] = 'n',
        ['�'] = 'o', ['�'] = 'p', ['�'] = 'r', ['�'] = 's', ['�'] = 't',
        ['�'] = 'u', ['�'] = 'f', ['�'] = 'h', ['�'] = 'ts', ['�'] = 'ch',
        ['�'] = 'sh', ['�'] = 'sch', ['�'] = '', ['�'] = 'y', ['�'] = '',
        ['�'] = 'e', ['�'] = 'yu', ['�'] = 'ya'
    }
    
    for k, v in pairs(char_table) do
        name = name:gsub(k, v)
    end
    
    return name
end
function isParamSampID(id)
	id = tonumber(id)
	if id ~= nil and tostring(id):find('%d') and not tostring(id):find('%D') and string.len(id) >= 1 and string.len(id) <= 3 then
		if id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
			return true
		elseif sampIsPlayerConnected(id) then
			return true
		else
			return false
		end
	else
		return false
	end
end
function play_error_sound()
	if not isMonetLoader() and sampIsLocalPlayerSpawned() then
		addOneOffSound(getCharCoordinates(PLAYER_PED), 1149)
	end
	show_arz_notify('error', 'Justice Helper', "��������� ������!", 1500)
end
function show_fast_menu(id)
	if isParamSampID(id) then 
		sampAddChatMessage('[Justice Helper] {ffffff}��������/������ ������� �� FastMenu ����� � /jh - RP ������� - ���������, �������� {arg_id}, �������', message_color)
		player_id = tonumber(id)
		FastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_fastmenu == nil then
			if not FastMenuPlayers[0] then
				sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/jm [ID]', message_color)
			end
		elseif settings.general.bind_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/jm [ID] {ffffff}��� ���������� �� ������ ����� ' .. message_color_hex .. '��� + ' .. getNameKeysFrom(settings.general.bind_fastmenu), message_color) 
		else
			sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/jm [ID]', message_color)
		end 
		play_error_sound()
	end 
end
function show_leader_fast_menu(id)
	if isParamSampID(id) then
		player_id = tonumber(id)
		sampAddChatMessage('[Justice Helper] {ffffff}��������/������ ������� �� FastMenu ����� � /jh - RP ������� - ���������, �������� {arg_id}, �������', message_color)
		LeaderFastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_leader_fastmenu == nil then
			sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/jlm [ID]', message_color)
		elseif settings.general.bind_leader_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/jlm [ID] {ffffff}��� ���������� �� ������ ����� ' .. message_color_hex .. '��� + ' .. getNameKeysFrom(settings.general.bind_leader_fastmenu), message_color) 
		else
			sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. '/jlm [ID]', message_color)
		end 
		play_error_sound()
	end
end
function get_players()
	local myPlayerId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
	local playersInRange = {}
	for temp1, h in pairs(getAllChars()) do
		temp2, id = sampGetPlayerIdByCharHandle(h)
		temp3, m = sampGetPlayerIdByCharHandle(PLAYER_PED)
		id = tonumber(id)
		if id ~= -1 and id ~= m and doesCharExist(h) then
			local x, y, z = getCharCoordinates(h)
			local mx, my, mz = getCharCoordinates(PLAYER_PED)
			local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
			if dist <= 5 then
				table.insert(playersInRange, id)
			end
		end
	end
	return playersInRange
end
function ifCommandPause()
	if command_stop then 
		command_stop = false 
		isActiveCommand = false
		if isMonetLoader() and settings.general.mobile_stop_button then
			CommandStopWindow[0] = false
		end
		sampAddChatMessage('[Justice Helper] {ffffff}��������� ������� ������� �����������!', message_color)  
		return true
	else
		return false
	end
end
function show_arz_notify(type, title, text, time)
	-- if isMonetLoader() then
	-- 	if type == 'info' then
	-- 		type = 3
	-- 	elseif type == 'error' then
	-- 		type = 2
	-- 	elseif type == 'success' then
	-- 		type = 1
	-- 	end
	-- 	local bs = raknetNewBitStream()
	-- 	raknetBitStreamWriteInt8(bs, 62)
	-- 	raknetBitStreamWriteInt8(bs, 6)
	-- 	raknetBitStreamWriteBool(bs, true)
	-- 	raknetEmulPacketReceiveBitStream(220, bs)
	-- 	raknetDeleteBitStream(bs)
	-- 	local json = encodeJson({
	-- 		styleInt = type,
	-- 		title = title,
	-- 		text = text,
	-- 		duration = time
	-- 	})
	-- 	local interfaceid = 6
	-- 	local subid = 0
	-- 	local bs = raknetNewBitStream()
	-- 	raknetBitStreamWriteInt8(bs, 84)
	-- 	raknetBitStreamWriteInt8(bs, interfaceid)
	-- 	raknetBitStreamWriteInt8(bs, subid)
	-- 	raknetBitStreamWriteInt32(bs, #json)
	-- 	raknetBitStreamWriteString(bs, json)
	-- 	raknetEmulPacketReceiveBitStream(220, bs)
	-- 	raknetDeleteBitStream(bs)
	-- else
	-- 	local str = ('window.executeEvent(\'event.notify.initialize\', \'["%s", "%s", "%s", "%s"]\');'):format(type, title, text, time)
	-- 	local bs = raknetNewBitStream()
	-- 	raknetBitStreamWriteInt8(bs, 18)
	-- 	raknetBitStreamWriteInt32(bs, 0)
	-- 	raknetBitStreamWriteInt32(bs, #str)
	-- 	raknetBitStreamWriteString(bs, str)
	-- 	raknetEmulPacketReceiveBitStream(220, bs)
	-- 	raknetDeleteBitStream(bs)
	-- end
end
function send_cef(str)
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt8(bs, 220)
	raknetBitStreamWriteInt8(bs, 18)
	raknetBitStreamWriteInt16(bs, #str)
	raknetBitStreamWriteString(bs, str)
	raknetBitStreamWriteInt32(bs, 0)
	raknetSendBitStream(bs)
	raknetDeleteBitStream(bs)
  end
function run_code(code)
    local bs = raknetNewBitStream();
    raknetBitStreamWriteInt8(bs, 17);
    raknetBitStreamWriteInt32(bs, 0);
    raknetBitStreamWriteInt32(bs, string.len(code));
    raknetBitStreamWriteString(bs, code);
    raknetEmulPacketReceiveBitStream(220, bs);
    raknetDeleteBitStream(bs);
end
function openLink(link)
	if isMonetLoader() then
		gta._Z12AND_OpenLinkPKc(link)
	else
		os.execute("explorer " .. link)
	end
end
function sampGetPlayerIdByNickname(nick)
	local id = nil
	nick = tostring(nick)
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if sampGetPlayerNickname(myid):find(nick) then return myid end
	for i = 0, 999 do
	    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i):find(nick) then
		   id = i
		   break
	    end
	end
	if id == nil then
		sampAddChatMessage('[Justice Helper] {ffffff}������: �� ������� �������� ID ������!', message_color)
		id = ''
	end
	return id
end

local gunOn = {}
local gunOff = {}
local gunPartOn = {}
local gunPartOff = {}
local oldGun = nil
local nowGun = 0

function init_guns()
    gunOn = {}
    gunOff = {}
    gunPartOn = {}
    gunPartOff = {}
    for _, weapon in ipairs(rp_guns) do
        local id = weapon.id
        local rpTakeType = rpTakeNames[tonumber(weapon.rpTake)]
    
        gunPartOn[id] = rpTakeType[1]
        gunPartOff[id] = rpTakeType[2]
    
        if (id == 3 or (id > 15 and id < 19) or (id == 90 or id == 91)) then
            gunOn[id] = (settings.player_info.sex == "�������") and "�����" or "����"
        else
            gunOn[id] = (settings.player_info.sex == "�������") and "�������" or "������"
        end
    
        if (id == 3 or (id > 15 and id < 19) or (id > 38 and id < 41) or (id == 90 or id == 91)) then
            gunOff[id] = (settings.player_info.sex == "�������") and "��������" or "�������"
        else
            gunOff[id] = (settings.player_info.sex == "�������") and "������" or "�����"
        end
    end
end
if settings.general.rp_gun then
    init_guns()
end
function get_name_weapon(id) 
    for _, weapon in ipairs(rp_guns) do
        if weapon.id == id then
            return weapon.name
        end
    end
    return "������"
end
function isExistsWeapon(id) 
    for _, weapon in ipairs(rp_guns) do
        if weapon.id == id then
            return true
        end
    end
    return false
end
function isEnableWeapon(id) 
    for _, weapon in ipairs(rp_guns) do
        if weapon.id == id then
            return weapon.enable
        end
    end
    return false
end

function format_patrool_time(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    if hours > 0 then
        return string.format("%d ����� %d ����� %d ������", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%d ����� %d ������", minutes, secs)
    else
        return string.format("%d ������(-�)", secs)
    end
end
function getNameOfARZVehicleModel(id)
	local need_download_arzveh = false
	if doesFileExist(path_arzvehicles) then
		if arzvehicles and #arzvehicles ~= 0 then
			local check = false
			for _, vehicle in ipairs(arzvehicles) do
				if vehicle.model_id == id then
					check = true
					--sampAddChatMessage("[Justice Helper] {ffffff}����� ��������� ��������� � ��� ��� " .. vehicle.name ..  " [ID " .. id .. "].", message_color)
					return " " .. vehicle.name
				end
			end
			if not check then
				need_download_arzveh = true
			end
		else
			sampAddChatMessage('[Justice Helper] {ffffff}�� ������� �������� ������ �/c � ID ' .. id .. "! �������: ������ ������������� VehiclesArizona.json", message_color)
			need_download_arzveh = true
		end
	else
		sampAddChatMessage('[Justice Helper] {ffffff}�� ������� �������� ������ �/c � ID ' .. id .. "! �������: ���������� ���� VehiclesArizona.json", message_color)
		need_download_arzveh = true
	end
	if need_download_arzveh then
		sampAddChatMessage('[Justice Helper] {ffffff}������� ������� ���� VehiclesArizona.json � ����� ' .. path_arzvehicles, message_color)
		download_arzvehicles = true
		downloadFileFromUrlToPath('https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/VehiclesArizona/VehiclesArizona.json', path_arzvehicles)
		return ' ������������� ��������'
	end
end
function kvadrat()
    local KV = {
        [1] = "�",
        [2] = "�",
        [3] = "�",
        [4] = "�",
        [5] = "�",
        [6] = "�",
        [7] = "�",
        [8] = "�",
        [9] = "�",
        [10] = "�",
        [11] = "�",
        [12] = "�",
        [13] = "�",
        [14] = "�",
        [15] = "�",
        [16] = "�",
        [17] = "�",
        [18] = "�",
        [19] = "�",
        [20] = "�",
        [21] = "�",
        [22] = "�",
        [23] = "�",
        [24] = "�",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
	if Y ~= nil then
		local KVX = (Y.."-"..X)
		return KVX
	else
		return X
	end
   
end
function calculateZoneRu(x, y, z)
    local streets = {
        {"���� ������", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"��������", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"���� ������", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"��������", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"������", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"�����-�����", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"��������� ��", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"�������� ����", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"����������� ��������", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"���� ������", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"�����", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"������� �����", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"�������� ���� ��", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"���-������", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"������", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"�������� �����-���", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"������� �����", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"��������� ���������", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"������� ������", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"������� ������", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"����������� ����������", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"���� ��������", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"������� ������-����", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"������� �����", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"����������", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"����������", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"���� ������", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"����������", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"��������� �����", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"����������", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"�������� �����", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"�����", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"������� ���������", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"������� �����", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"�������� ��������", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"��������� �������", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"����������� ��������", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"��������", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"�����-����", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"�����", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"������", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"������� �����", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"�����-����", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"������� �����", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"����������� ��������", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"��������� �����", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"����������", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"������ ������", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"������� ��������", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"��������", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"����������", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"���� ��� ������", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"�����", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"����������", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"����������", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"������-��������", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"���-�������", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"���-�������", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"������", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"�������� ����", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"�������� �����", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"����������", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"�������� �����", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"�����", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"��������� �������", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"�����", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"��������", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"������", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"�����", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"��������� ��", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"���������� �����", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"����������", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"���-�������", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"���������� �����", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"�����", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"���-������", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"���������� �����", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"�����", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"�������", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"�����", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"�������� �����", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"������� �����", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"�����", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"����������", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"�������-�����", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"�����", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"���� �������", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"���� ������", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"������������ �����", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"����������", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"�����", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"����������", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"����������", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"����� �����", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"�������", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"��������� ����", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"������������ �����", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"�������� �����", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"�����", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"���� ����", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"�������� �����-���", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"���� ������", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"�����", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"����������", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"����� ������", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"��������", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"�������", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"��������� ���������", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"������� �����", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"���� ����", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"�����", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"������� �������", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"����������", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"���� ����", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"���-�������", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"����������", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"�������� �����", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"������������ �����", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"�����", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"����-���������", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"�����", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"����������� �����", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"���-�������", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"����������", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"�����", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"��������� ��������", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"������� �����", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"��������� �����", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"������", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"�����-�����", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"������� ���������", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"���� ����", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"�������� ����", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"��������-���", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"���� ������", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"��������� ��", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"������ ��������", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"�������", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"��������", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"�������", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"�����", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"������� �����", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"������������ �����", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"��������� ��", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"����� ������", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"������", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"�������", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"��������� ��", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"�����", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"��������� �������", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"�����", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"��������� ��������", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"������", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"�������", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"����������� ����������", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"����������", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"�����", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"�����-����", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"��������", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"���� ������", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"���� ������", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"���� �������", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"���� �������", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"���� ������", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"������������", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"���� �������", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"���� �������", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"������������ �����", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"����������� �����", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"�������� ������", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"�������� �����", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"��������� ����", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"���� ������", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"����������", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"���������", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"��������� ������", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"��������� ����", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"�������� �����-���", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"������ �����", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"�����-�����", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"������", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"�������� ��������", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"������", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"������", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"��������� ����", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"����������", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"������� �����", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"������� �����", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"���� ������", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"����� �����", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"��������� ��", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"������� ���������", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"���-�������", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"����������", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"��������� ����", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"��������� ��", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"������", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"���� ������", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"����������", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"�������� ���������", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"������ ���-������", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"��������� ����", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"������", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"��������-������", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"�����", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"���-������", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"������� ��������", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"������� ������", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"�������� �����", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"���-������", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"������ �����", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"�����-����", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"���� ������", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"����������� ������", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"������-����", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"��������� ����", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"����������", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"�����", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"������������ �����", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"����������", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"����� ������", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"�������-�����", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"������ 4 �������", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"��������", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"�������� �����", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"���� ��� ������", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"�������", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"�������� ��������", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"������", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"����� �������", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"���-���������", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"������ ������", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"���� ����", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"���� ������", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"�����", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"�������", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"��������", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"�������-�������", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"�������������", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"���-������", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"������� �����", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"������ ������", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"���-��������", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"������ ���������", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"����������� ��������", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"������", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"�������� �����-���", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"��������� ��������", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"��������� ���������", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"������ ��������", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"������ �����", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"������", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"������", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"����������", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"������� �����", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"�����-�����-�����", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"������� ����� �������", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"����� �����-����", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"������� �������", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"��������� ����", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"������", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"��������� ���������", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"��������� ����", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"�����-�����", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"��������", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"������� ������", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"���� ����", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"������� �����", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"�������� ��������", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"������", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"���� ����", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"��� Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"����������� �����", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"���-�������", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"������-����-����", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"���������� ������", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"��������� ������", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"�����-�����", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"�����-����-������", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"����������� �����", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"�����", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"����������� ������", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"��������", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"��������", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"��������", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"������� ���", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"��������", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"���-��������", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"�������� ���������", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"�������� �����-���", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"�������� ������", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"����������", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"��������� ����", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"���-������� �����", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"�������� �����", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"����������� �����", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"�������� ������", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"�����-����", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"����� �����", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"����-������", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"�������� ����", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"�����-����", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"��������", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"��������� ������", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"������� �����", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"��������� ������", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"����� ���-������", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"��������", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"������", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"���-��������-�����", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"��������-����", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"��������-������", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"����-���������", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"���������� �����", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"���� ������", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"������ ������", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"����-����-�����", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"������� ������", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"�����", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"����� �������", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"�������� ���������", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"���������� �����", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"������", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"����������", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"����", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"��������", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"���� �����-�����", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"����������� ����������", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"�������-����", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"¸�����-������", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"�����-�������", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"������ ���-�-���", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"�������� ��������", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"���� �����-�����", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"������������", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"��������", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"����� �����", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"������������", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"�������� ����", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"��������� ����", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"�������� �����-���", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"�������-�������", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"������-�����", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"����� �����", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"����� ��", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"������", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"���� ������", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"����-������", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"������ ������", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"�����-�����", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"����-����", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"�������", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"��������", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"�������� ��������", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"���������", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"����-���", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"������ ������", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"��������", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"���������-����", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"����� ��", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"��������� ����", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"���� ������", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"���� ������", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"�������� �����-���", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"����������", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"�������� �����", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"���-�-������", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"���� ������", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"������ ������", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"����� �����", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"��������", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
        {"��������� �����", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
        {"������ ������", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
        {"���������� ��", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
        {"���������� ��", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
        {"�������� �����", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
        {"���������� ��", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return '����������'
end
function argbToRgbNormalized(argb)
    local a = math.floor(argb / 0x1000000) % 0x100
    local r = math.floor(argb / 0x10000) % 0x100
    local g = math.floor(argb / 0x100) % 0x100
    local b = argb % 0x100
    local normalizedR = r / 255.0
    local normalizedG = g / 255.0
    local normalizedB = b / 255.0
    return {normalizedR, normalizedG, normalizedB}
end
local servers = {
	{name = 'Phoenix', number = '01'},
	{name = 'Tucson', number = '02'},
	{name = 'Scottdale', number = '03'},
	{name = 'Chandler', number = '04'},
	{name = 'Brainburg', number = '05'},
	{name = 'SaintRose', number = '06'},
	{name = 'Mesa', number = '07'},
	{name = 'Red Rock', number = '08'},
	{name = 'Yuma', number = '09'},
	{name = 'Surprise', number = '10'},
	{name = 'Prescott', number = '11'},
	{name = 'Glendale', number = '12'},
	{name = 'Kingman', number = '13'},
	{name = 'Winslow', number = '14'},
	{name = 'Payson', number = '15'},
	{name = 'Gilbert', number = '16'},
	{name = 'Show Low', number = '17'},
	{name = 'Casa Grande', number = '18'},
	{name = 'Page', number = '19'},
	{name = 'Sun City', number = '20'},
	{name = 'Queen Creek', number = '21'},
	{name = 'Sedona', number = '22'},
	{name = 'Holiday', number = '23'},
	{name = 'Wednesday', number = '24'},
	{name = 'Yava', number = '25'},
	{name = 'Faraway', number = '26'},
	{name = 'Bumble Bee', number = '27'},
	{name = 'Christmas', number = '28'},
	{name = 'Mirage', number = '29'},
	{name = 'Love', number = '30'},
	{name = 'Drake', number = '31'},
	{name = 'Mobile III', number = '103'},
	{name = 'Mobile II', number = '102'},
	{name = 'Mobile I', number = '101'},
	{name = 'Vice City', number = '200'},
}
function getARZServerNumber()
	local server = "0"
	for _, s in ipairs(servers) do
		if sampGetCurrentServerName():find(s.name) or sampGetCurrentServerName():gsub('%-', ' '):find(s.name) or sampGetCurrentServerName():gsub('-', ' '):find(s.name) then
			server = s.number
			break
		end
	end
	return server
end
function getARZServerName(number)
	local server = ''
	for _, s in ipairs(servers) do
		if tostring(number) == tostring(s.number) then
			server = s.name
			break
		end
	end
	return server
end
function check_update()
	print('[Justice Helper] ������� �������� �� ������� ����������...')
	sampAddChatMessage('[Justice Helper] {ffffff}������� �������� �� ������� ����������...', message_color)
	local path = configDirectory .. "/Update_Info.json"
	os.remove(path)
	local url = 'https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/Update_Info.json'
	if isMonetLoader() then
		downloadToFile(url, path, function(type, pos, total_size)
			if type == "finished" then
				local updateInfo = readJsonFile(path)
				if updateInfo then
					local uVer = updateInfo.current_version
					local uUrl = updateInfo.update_url
					local uText = updateInfo.update_info
					print("[Justice Helper] ������� ������������� ������:", thisScript().version)
					print("[Justice Helper] ������� ������ � ������:", uVer)
					if thisScript().version ~= uVer then
						print('[Justice Helper] �������� ����������!')
						sampAddChatMessage('[Justice Helper] {ffffff}�������� ����������!', message_color)
						need_update_helper = true
						updateUrl = uUrl
						updateVer = uVer
						updateInfoText = uText
						UpdateWindow[0] = true
					else
						print('[Justice Helper] ���������� �� �����!')
						sampAddChatMessage('[Justice Helper] {ffffff}���������� �� �����, � ��� ���������� ������!', message_color)
					end
				end
			end
		end)
	else
		downloadUrlToFile(url, path, function(id, status)
			if status == 6 then -- ENDDOWNLOADDATA
				local updateInfo = readJsonFile(path)
				if updateInfo then
					local uVer = updateInfo.current_version
					local uUrl = updateInfo.update_url
					local uText = updateInfo.update_info
					print("[Justice Helper] ������� ������������� ������:", thisScript().version)
					print("[Justice Helper] ������� ������ � ������:", uVer)
					if thisScript().version ~= uVer then
						print('[Justice Helper] �������� ����������!')
						sampAddChatMessage('[Justice Helper] {ffffff}�������� ����������!', message_color)
						need_update_helper = true
						updateUrl = uUrl
						updateVer = uVer
						updateInfoText = uText
						UpdateWindow[0] = true
					else
						print('[Justice Helper] ���������� �� �����!')
						sampAddChatMessage('[Justice Helper] {ffffff}���������� �� �����, � ��� ���������� ������!', message_color)
					end
				end
			end
		end)
	end
	function readJsonFile(filePath)
		if not doesFileExist(filePath) then
			print("[Justice Helper] ������: ���� " .. filePath .. " �� ����������")
			return nil
		end
		local file = io.open(filePath, "r")
		local content = file:read("*a")
		file:close()
		local jsonData = decodeJson(content)
		if not jsonData then
			print("[Justice Helper] ������: �������� ������ JSON � ����� " .. filePath)
			return nil
		end
		return jsonData
	end
end
function downloadToFile(url, path, callback, progressInterval)
	callback = callback or function() end
	progressInterval = progressInterval or 0.1

	local effil = require("effil")
	local progressChannel = effil.channel(0)

	local runner = effil.thread(function(url, path)
	local http = require("socket.http")
	local ltn = require("ltn12")

	local r, c, h = http.request({
		method = "HEAD",
		url = url,
	})

	if c ~= 200 then
		return false, c
	end
	local total_size = h["content-length"]

	local f = io.open(path, "wb")
	if not f then
		return false, "failed to open file"
	end
	local success, res, status_code = pcall(http.request, {
		method = "GET",
		url = url,
		sink = function(chunk, err)
		local clock = os.clock()
		if chunk and not lastProgress or (clock - lastProgress) >= progressInterval then
			progressChannel:push("downloading", f:seek("end"), total_size)
			lastProgress = os.clock()
		elseif err then
			progressChannel:push("error", err)
		end

		return ltn.sink.file(f)(chunk, err)
		end,
	})

	if not success then
		return false, res
	end

	if not res then
		return false, status_code
	end

	return true, total_size
	end)
	local thread = runner(url, path)

	local function checkStatus()
	local tstatus = thread:status()
	if tstatus == "failed" or tstatus == "completed" then
		local result, value = thread:get()

		if result then
		callback("finished", value)
		else
		callback("error", value)
		end

		return true
	end
	end

	lua_thread.create(function()
	if checkStatus() then
		return
	end

	while thread:status() == "running" do
		if progressChannel:size() > 0 then
		local type, pos, total_size = progressChannel:pop()
		callback(type, pos, total_size)
		end
		wait(0)
	end

	checkStatus()
	end)
end
function downloadFileFromUrlToPath(url, path)
	print('[Justice Helper] ������� ���������� ����� � ' .. path)
	if isMonetLoader() then
		downloadToFile(url, path, function(type, pos, total_size)
			if type == "downloading" then
				--print(("���������� %d/%d"):format(pos, total_size))
			elseif type == "finished" then
				if download_helper then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ����� ������ ������� ��������� �������! ������������..',  message_color)
					reload_script = true
					thisScript():unload()
				elseif download_smartuk then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ����� ������ ������� ��� ������� ' .. getARZServerName(getARZServerNumber()) .. '[' .. getARZServerNumber() ..  '] ��������� �������!',  message_color)
					sampAddChatMessage('[Justice Helper] {ffffff}��� ������ ������� ����������� ' .. message_color_hex .. '/sum ID',  message_color)
					download_smartuk = false
					load_smart_uk()
				elseif download_smartpdd then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ����� ������ ������� ��� ������� ' .. getARZServerName(getARZServerNumber()) .. '[' .. getARZServerNumber() ..  '] ��������� �������!',  message_color)
					sampAddChatMessage('[Justice Helper] {ffffff}��� ������ ������� ����������� ' .. message_color_hex .. '/tsm ID',  message_color)
					download_smartpdd = false
					load_smart_pdd()
				elseif download_arzvehicles then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ������ ������� ������ ����� ������� ���������� �������!',  message_color)
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ����������� ������ ������� ������� ������� ����������� ������ �/c.',  message_color)
					download_arzvehicles = false
					load_arzvehicles()
				end
			elseif type == "error" then
				sampAddChatMessage('[Justice Helper] {ffffff}������ ��������: ' .. pos,  message_color)
			end
		end)
	else
		downloadUrlToFile(url, path, function(id, status)
			if status == 6 then -- ENDDOWNLOADDATA
				if download_helper then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ����� ������ ������� ��������� �������! ������������..',  message_color)
					reload_script = true
					thisScript():unload()
				elseif download_smartuk then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ����� ������ ������� ��� ������� ' .. getARZServerName(getARZServerNumber()) .. '[' .. getARZServerNumber() ..  '] ��������� �������!',  message_color)
					sampAddChatMessage('[Justice Helper] {ffffff}��� ������ ������� ����������� ' .. message_color_hex .. '/sum ID',  message_color)
					
					download_smartuk = false
					load_smart_uk()
				elseif download_smartpdd then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ����� ������ ������� ��� ������� ' .. getARZServerName(getARZServerNumber()) .. '[' .. getARZServerNumber() ..  '] ��������� �������!',  message_color)
					sampAddChatMessage('[Justice Helper] {ffffff}��� ������ ������� ����������� ' .. message_color_hex .. '/tsm ID',  message_color)
					download_smartpdd = false
					load_smart_pdd()
				elseif download_arzvehicles then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ������ ������� ������ ����� ������� ���������� �������!',  message_color)
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ����������� ������ ������� ������� ������� ����������� ������ �/c.',  message_color)
					download_arzvehicles = false
					load_arzvehicles()
				end
			end
		end)
	end
end
function split_text_into_lines(text, max_length)
	local lines = {}
	local current_line = ""
	for word in text:gmatch("%S+") do
		local new_line = current_line .. (current_line == "" and "" or " ") .. word
		if #new_line > max_length then
			table.insert(lines, current_line)
			current_line = word
		else
			current_line = new_line
		end
	end

	if current_line ~= "" then
		table.insert(lines, current_line)
	end

	return table.concat(lines, "\n")
end
function count_lines_in_text(text, max_length)
	local lines = {}
	local current_line = ""

	-- ��������� ����� �� �����
	for word in text:gmatch("%S+") do
		local new_line = current_line .. (current_line == "" and "" or " ") .. word
		if #new_line > max_length then
			table.insert(lines, current_line)
			current_line = word
		else
			current_line = new_line
		end
	end

	if current_line ~= "" then
		table.insert(lines, current_line)
	end

	return tonumber(#lines)
end
local sampev = require('samp.events')
function sampev.onShowTextDraw(id, data)
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~r~Sport!') then
		sampAddChatMessage('[Justice Helper] {ffffff}����������� ����� ���� Sport!', message_color)
		return false
	end
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
		sampAddChatMessage('[Justice Helper] {ffffff}����������� ����� ���� Comfort!', message_color)
		return false
	end
end
function sampev.onDisplayGameText(style,time,text)
	if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~r~Sport!') then
		sampAddChatMessage('[Justice Helper] {ffffff}����������� ����� ���� Sport!', message_color)
		return false
	end
	if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
		sampAddChatMessage('[Justice Helper] {ffffff}����������� ����� ���� Comfort!', message_color)
		return false
	end
end
function sampev.onSendTakeDamage(playerId,damage,weapon)
	if playerId ~= 65535 then
		playerId2 = playerId1
		playerId1 = playerId
		if isParamSampID(playerId) and playerId1 ~= playerId2 and tonumber(playerId) ~= 0 and weapon then
			local weapon_name = get_name_weapon(weapon)
			if weapon_name then
				sampAddChatMessage('[Justice Helper] {ffffff}����� ' .. sampGetPlayerNickname(playerId) .. '[' .. playerId .. '] ����� �� ��� ��������� ' .. weapon_name .. '['.. weapon .. ']!', message_color)
				--sampSendChat(' /rep ������� �� ID ' .. playerId ..', ����� �� ���� ��������� ' .. weapon_name)
				if ComboPatroolCode[0] ~= 1 then
					sampAddChatMessage('[Justice Helper - ���������] {ffffff}��� ������������ ��� ������ �� CODE 0.', message_color)
					ComboPatroolCode[0] = 1
					patrool_code = combo_patrool_code_list[ComboPatroolCode[0] + 1]
				end
				
				--table.insert(damage, {nick = sampGetPlayerNickname(playerId), weapon_id = weapon})
			end
		end
	end
end
function sampev.onServerMessage(color,text)
	--sampAddChatMessage('color = ' .. color .. ' ' .. argbToHex(color) ' text = '..text,-1)
	if (settings.general.auto_uval and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		if text:find("%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb ��� /r /rb ��� ���� 
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			lua_thread.create(function ()
				wait(50)
				if ((not message:find(" ��������� (.+) +++ ����� �������� ���!") and not message:find("��������� (.+) ��� ������ �� �������(.+)")) and (message:rupper():find("���") or message:rupper():find("���.") or message:rupper():find("�������") or message:find("�������.") or message:rupper():find("����") or message:rupper():find("����."))) then
					message3 = message2
					message2 = message1
					message1 = text
					PlayerID = playerID
					sampAddChatMessage(text, 0xFF2DB043)
					if message3 == text then
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] ��������...')
					elseif tag == "R" then
						sampSendChat("/rb "..name.." ��������� /rb +++ ����� �������� ���!")
					elseif tag == "F" then
						sampSendChat("/fb "..name.." ��������� /fb +++ ����� �������� ���!")
					end
				elseif ((message == "(( +++ ))" or message == "(( +++. ))") and (PlayerID == playerID)) then
					sampAddChatMessage(text, 0xFF2DB043)
					auto_uval_checker = true
					sampSendChat('/fmute ' .. PlayerID .. ' 1 [AutoUval] ��������...')
				end
			end)
		elseif text:find("%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r ��� /f � �����
			local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			lua_thread.create(function ()
				wait(50)
				if not message:find(" ��������� (.+) +++ ����� �������� ���!") and not message:find("��������� (.+) ��� ������ �� �������(.+)") and message:rupper():find("���") or message:rupper():find("���.") or message:rupper():find("�������") or message:find("�������.") or message:rupper():find("����") or message:rupper():find("����.") then
					message3 = message2
					message2 = message1
					message1 = text
					PlayerID = playerID	
					sampAddChatMessage(text, 0xFF2DB043)
					if message3 == text then
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] ��������...')
					elseif tag == "R" then
						sampSendChat("/rb "..name.."["..playerID.."], ��������� /rb +++ ����� �������� ���!")
					elseif tag == "F" then
						sampSendChat("/fb "..name.."["..playerID.."], ��������� /fb +++ ����� �������� ���!")
					end
				elseif ((message == "(( +++ ))" or  message == "(( +++. ))") and (PlayerID == playerID)) then
					auto_uval_checker = true
					sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] ��������...')
				end
			end)
		end
		
		if text:find("(.+) ��������%(�%) ������ (.+) �� 1 �����. �������: %[AutoUval%] ��������...") and auto_uval_checker then
			local Name, PlayerName, Time, Reason = text:match("(.+) ��������%(�%) ������ (.+) �� (%d+) �����. �������: (.+)")
			local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			lua_thread.create(function ()
				wait(50)
				if Name == MyName then
					sampAddChatMessage('[Justice Helper] {ffffff}�������� ������ ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
					auto_uval_checker = false
					temp = PlayerID .. ' ���'
					find_and_use_command("/uninvite {arg_id} {arg2}", temp)
				else
					sampAddChatMessage('[Justice Helper] {ffffff}������ �����������/����� ��� ��������� ������ ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
					auto_uval_checker = false
				end
			end)
		end
	end
	if tonumber(settings.player_info.fraction_rank_number) >= 5 then
		if text:find("%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb ��� /r /rb ��� ���� 
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			if message:find('����� �������� � ������ (%d) ������� ���� N(%d+)%. �������%: (.+)') then
				local lvl, id, reason = message:match('����� �������� � ������ (%d) ������� ���� N(%d+)%. �������%: (.+)')
				form_su = id .. ' ' .. lvl .. ' ' .. reason
				sampAddChatMessage('[Justice Helper] {ffffff}����������� /givefsu ' .. playerID .. ' ����� ������ ������ �� ������� ������� ' .. name, message_color)
			end
		elseif text:find("%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r ��� /f � �����
			local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			local lvl, id, reason = message:match('����� �������� � ������ (%d) ������� ���� N(%d+)%. �������%: (.+)')
				form_su = id .. ' ' .. lvl .. ' ' .. reason
				sampAddChatMessage('[Justice Helper] {ffffff}����������� /givefsu ' .. playerID .. ' ����� ������ ������ �� ������� ������� ' .. name, message_color)
		end
	end
	if (text:find("� (.+) ����������� �������� ������. �� ������ ������ ��� ������ � ������� ������� /givewbook") and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		local nick = text:match("� (.+) ����������� �������� ������. �� ������ ������ ��� ������ � ������� ������� /givewbook")
		local cmd = '/givewbook'
		for _, command in ipairs(commands.commands_manage) do
			if command.enable and command.text:find('/givewbook {arg_id}') then
				cmd =  '/' .. command.cmd
			end
		end
		sampAddChatMessage('[Justice Helper] {ffffff}� ������ ' .. nick .. ' ���� �������� ������, ������� � ��������� ' .. message_color_hex .. cmd .. ' ' .. sampGetPlayerIdByNickname(nick), message_color)
		return false
	end
	if (settings.general.auto_mask) then
		if text:find('����� �������� ����� �������, ��� �������� �� ���������.') then
			sampAddChatMessage('[Justice Helper] {ffffff}����� �������� ����� �������! ������������� ������� �����', message_color)
			sampProcessChatInput("/mask")
			return false
		elseif (text:find('����� �������� ����� (%d+) �����, ����� ������ ������� �� ������� ���������.')) then
			local min = text:match('����� �������� ����� (%d+) �����, ����� ������ ������� �� ������� ���������.')
			sampAddChatMessage('[Justice Helper] {ffffff}����� �������� ����� ' .. min .. ' �����, ����� ������ ������� ������������� ������ �����!', message_color)
			return false
		end
	end 
	if text:find("1%.{6495ED} 111 %- {FFFFFF}��������� ������ ��������") or
		text:find("2%.{6495ED} 060 %- {FFFFFF}������ ������� �������") or
		text:find("3%.{6495ED} 911 %- {FFFFFF}����������� �������") or
		text:find("4%.{6495ED} 912 %- {FFFFFF}������ ������") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}�����") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}�������") or
		text:find("6%.{6495ED} 8828 %- {FFFFFF}���������� ������������ �����") or
		text:find("7%.{6495ED} 997 %- {FFFFFF}������ �� �������� ����� ������������ %(������ ��������� ����%)") then
		return false
	end
	if text:find("������ ��������� ��������������� �����:") then
		sampAddChatMessage('[Justice Helper] {ffffff}������ ��������� ��������������� �����:', message_color)
		sampAddChatMessage('[Justice Helper] {ffffff}111 ������ | 60 ����� | 911 �� | 912 �� | 913 ����� | 914 ���� | 8828 ���� | 997 ����', message_color)
		return false
	end
	if text:find ('{FFFFFF}����� �������� ����� 20 �����, ����� ������ ������� �� ������� ���������.') then
		sampAddChatMessage('[Justice Helper] {ffffff}����� �������� ����� 20 �����, ����� ������ ������� ������������� ������ �����', message_color)
		return false
	end
	if text:find("�� ������� ������ �����") then
		maska = true
		sampAddChatMessage('[Justice Helper] {ffffff}�� ������ �����', message_color)
		return false
	end
	if text:find("������ �� � �����") then
		return false
	end
	if text:find("�� ������� �������� �����") or text:find("�� ����� �����") then
		sampAddChatMessage('[Justice Helper] {ffffff}�� ����� �����!', message_color)
		return false
	end
	if text:find('%[������%] %{FFFFFF%}���������: %/wanted %[������� ������� 1%-6%]') and check_wanted then
		return false
	end
	if text:find('%[������%] {FFFFFF}������� � ����� ������� ������� ����!') and check_wanted then 
		return false 
	end
	if text:find('�� ���� ���������� ��� ����������� ����������.') and patrool_active then
		sampSendChat('/delvdesc')
		lua_thread.create(function ()
			wait(5000)
			sampSendChat('/vdesc ' .. tagReplacements.get_patrool_mark())
		end)		
	end
end

function sampev.onSendChat(text)
    if debug_mode then
        sampAddChatMessage('[JH DEBUG] {ffffff}' .. text, message_color)
    end
    local ignore = {
        [";)"] = true,
        [":D"] = true,
        [":O"] = true,
        [":|"] = true,
        [")"] = true,
        ["))"] = true,
        ["("] = true,
        ["(("] = true,
        ["xD"] = true,
        ["q"] = true,
        ["(+)"] = true,
        ["(-)"] = true,
        [":)"] = true,
        [":("] = true,
        ["=)"] = true,
        [":p"] = true,
        [";p"] = true,
        ["(rofl)"] = true,
        ["XD"] = true,
        ["(agr)"] = true,
        ["O.o"] = true,
        [">.<"] = true,
        [">:("] = true,
        ["<3"] = true,
    }
    if ignore[text] then
        return {text}
    end
    if settings.general.rp_chat then
        text = text:sub(1, 1):rupper()..text:sub(2, #text) 
        if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
            text = text .. '.'
        end
    end
    if settings.general.accent_enable then
        text = settings.player_info.accent .. ' ' .. text 
    end
    return {text}
end

function sampev.onSendChat(text)
    if debug_mode then
        sampAddChatMessage('[JH DEBUG] {ffffff}' .. text, message_color)
    end
    local ignore = {
        [";)"] = true,
        [":D"] = true,
        [":O"] = true,
        [":|"] = true,
        [")"] = true,
        ["))"] = true,
        ["("] = true,
        ["(("] = true,
        ["xD"] = true,
        ["q"] = true,
        ["(+)"] = true,
        ["(-)"] = true,
        [":)"] = true,
        [":("] = true,
        ["=)"] = true,
        [":p"] = true,
        [";p"] = true,
        ["(rofl)"] = true,
        ["XD"] = true,
        ["(agr)"] = true,
        ["O.o"] = true,
        [">.<"] = true,
        [">:("] = true,
        ["<3"] = true,
    }
    if ignore[text] then
        return {text}
    end
    if settings.general.rp_chat then
        text = text:sub(1, 1):rupper()..text:sub(2, #text) 
        if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
            text = text .. '.'
        end
    end
    if settings.general.accent_enable then
        text = settings.player_info.accent .. ' ' .. text 
    end
    return {text}
end

function sampev.onSendCommand(text)
    if debug_mode then
        sampAddChatMessage('[JH DEBUG] {ffffff}' .. text, message_color)
    end
    if settings.general.rp_chat then
        local chats = {'/s', '/r', '/m', '/do'} 
        for _, cmd in ipairs(chats) do
            if text:find('^'.. cmd .. ' ') then
                local cmd_text = text:match('^'.. cmd .. ' (.+)')
                if cmd_text ~= nil then
                    cmd_text = cmd_text:sub(1, 1):rupper()..cmd_text:sub(2, #cmd_text)
                    text = cmd .. ' ' .. cmd_text
                    -- ��������� ����� ������ ���� ��� �� /s � ��� ������������ �����
                    if cmd ~= '/s' and not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
                        text = text .. '.'
                    end
                end
            end
        end
    end
    return {text}
end
function sampev.onShowDialog(dialogid, style, title, button1, button2, text)
	
	if title:find('�������� ����������') and check_stats then -- ��������� ����������
		if text:find("{FFFFFF}���: {B83434}%[(.-)]") then
			settings.player_info.name_surname = TranslateNick(text:match("{FFFFFF}���: {B83434}%[(.-)]"))
			input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
			sampAddChatMessage('[Justice Helper] {ffffff}���� ��� � ������� ����������, �� - ' .. settings.player_info.name_surname, message_color)
		end
		if text:find("{FFFFFF}���: {B83434}%[(.-)]") then
			settings.player_info.sex = text:match("{FFFFFF}���: {B83434}%[(.-)]")
			sampAddChatMessage('[Justice Helper] {ffffff}��� ��� ���������, �� - ' .. settings.player_info.sex, message_color)
		end
		if text:find("{FFFFFF}�����������: {B83434}%[(.-)]") then
			settings.player_info.fraction = text:match("{FFFFFF}�����������: {B83434}%[(.-)]")
			if settings.player_info.fraction == '�� �������' then
				sampAddChatMessage('[Justice Helper] {ffffff}�� �� �������� � �����������!',message_color)
				settings.player_info.fraction_tag = "����������"
			else
				sampAddChatMessage('[Justice Helper] {ffffff}���� ����������� ����������, ���: '..settings.player_info.fraction, message_color)
				if settings.player_info.fraction == '������� ��' or settings.player_info.fraction == '������� LS' then
					settings.player_info.fraction_tag = '����'
				elseif settings.player_info.fraction == '������� ��' or settings.player_info.fraction == '������� LV' then
					settings.player_info.fraction_tag = '����'
				elseif settings.player_info.fraction == '������� ��' or settings.player_info.fraction == '������� SF' then
					settings.player_info.fraction_tag = '����'
				elseif settings.player_info.fraction == '��������� �������' then
					settings.player_info.fraction_tag = '����'
				elseif settings.player_info.fraction == 'FBI' or settings.player_info.fraction == '���' then
					settings.player_info.fraction_tag = '���'
				elseif settings.player_info.fraction:find('������ �������� ������') then
					settings.player_info.fraction_tag = '���'
				elseif settings.player_info.fraction == '����� SF' or settings.player_info.fraction == '����� ��' then
					settings.player_info.fraction_tag = '���'
				elseif settings.player_info.fraction == '����� ��' or settings.player_info.fraction == '����� LS' then
					settings.player_info.fraction_tag = '���'
				else
					settings.player_info.fraction_tag = '��'
				end
				settings.deportament.dep_tag1 = '[' .. settings.player_info.fraction_tag .. ']'
				input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
				input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
				sampAddChatMessage('[Justice Helper] {ffffff}����� ����������� �������� ��� '..settings.player_info.fraction_tag .. ". �� �� ������ �������� ���.", message_color)
			end
		end
		if text:find("{FFFFFF}���������: {B83434}(.+)%((%d+)%)") then
			settings.player_info.fraction_rank, settings.player_info.fraction_rank_number = text:match("{FFFFFF}���������: {B83434}(.+)%((%d+)%)(.+)������� �������")
			sampAddChatMessage('[Justice Helper] {ffffff}���� ��������� ����������, ���: '..settings.player_info.fraction_rank.." ("..settings.player_info.fraction_rank_number..")", message_color)
			-- if tonumber(settings.player_info.fraction_rank_number) >= 9 then
			-- 	settings.general.auto_uval = true
			-- 	initialize_commands()
			-- end
		else
			settings.player_info.fraction_rank = "����������"
			settings.player_info.fraction_rank_number = 0
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ������, �� ���� �������� ��� ����!',message_color)
		end
		save_settings()
		sampSendDialogResponse(dialogid, 0,0,0)
		check_stats = false

		return false
	end

	if spawncar_bool and title:find('$') and text:find('����� ����������') then -- ����� ����������
		sampSendDialogResponse(dialogid, 1, 3, 0)
		spawncar_bool = false
		return false 
	end
	
	if vc_vize_bool and text:find('���������� ������������ �� ������������ � Vice City') then -- VS Visa [0]
		sampSendDialogResponse(dialogid, 1, 11, 0)
		return false 
	end
	
	if vc_vize_bool and title:find('������ ���������� �� ������� Vice City') then -- VS Visa [1]
		vc_vize_bool = false
		sampSendChat("/r ���������� "..TranslateNick(sampGetPlayerNickname(tonumber(vc_vize_player_id))).." ������ ���� Vice City!")
		sampSendDialogResponse(dialogid, 1, 0, tostring(vc_vize_player_id))
		return false 
	end
	
	if vc_vize_bool and title:find('������� ���������� �� ������� Vice City') then -- VS Visa [2]
		vc_vize_bool = false
		sampSendChat("/r � ���������� "..TranslateNick(sampGetPlayerNickname(tonumber(vc_vize_player_id))).." ���� ������ ���� Vice City!")
		sampSendDialogResponse(dialogid, 1, 0, tostring(sampGetPlayerNickname(vc_vize_player_id)))
		return false 
	end

	if title:find('�������� �����') then -- arz fastmenu
		sampSendDialogResponse(dialogid, 0, 2, 0)
		return false 
	end

	if members_check and title:find('(.+)%(� ����: (%d+)%)') then -- ������� 
	
        local count = 0
        local next_page = false
        local next_page_i = 0
		members_fraction = string.match(title, '(.+)%(� ����')
		members_fraction = string.gsub(members_fraction, '{(.+)}', '')
        for line in text:gmatch('[^\r\n]+') do
            count = count + 1
            if not line:find('���') and not line:find('��������') then

				line = line:gsub("{FFA500}%(��%)", "")
				line = line:gsub(" %/ � ���������", "")

				--line = line:gsub("  ", "")
				--local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(......)}(.+)%((%d+)%)(.+)%((%d+)%)(.+){FFFFFF}(%d+) %[%d+%] %/ (%d+) %d+ ��")

				-- if nickname:find('%[%:(.+)%] (.+)') then
				-- 	tag, nick = nickname:match('%[(.+)%] (.+)')
				-- 	nickname = nick
				-- end

				if line:find('{FFA500}%(%d+.+%)') then
					local color, nickname, id, rank, rank_number, color2, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}([%w_]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*{(%x%x%x%x%x%x)}%(([^%)]+)%)%s*{FFFFFF}(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ ��")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end
						if rank_time then
							rank_number = rank_number .. ') (' .. rank_time
						end
						table.insert(members_new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working})
					end
				else
					local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}%s*([^%(]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*([^{}]+){FFFFFF}%s*(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ ��")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end

						table.insert(members_new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working})
					end
				end
				
				
				
            end
            if line:match('��������� ��������') then
                next_page = true
                next_page_i = count - 2
            end
        end
        if next_page then
            sampSendDialogResponse(dialogid, 1, next_page_i, 0)
            next_page = false
            next_pagei = 0
		elseif #members_new ~= 0 then
            sampSendDialogResponse(dialogid, 0, 0, 0)
			members = members_new
			members_check = false
			MembersWindow[0] = true
		else
			sampSendDialogResponse(dialogid, 0, 0, 0)
			sampAddChatMessage('[Justice Helper]{ffffff} ������ ����������� ����!', message_color)
			members_check = false
        end
        return false
    end

	if title:find('�������� ���� ��� (.+)') and text:find('��������') then -- invite
		sampSendDialogResponse(dialogid, 1, 0, 0)
		return false
	end

	if text:find('���') and text:find('������� �������') and text:find('����������') and check_wanted then
		local text = string.gsub(text, '%{......}', '')
		text = string.gsub(text, '���%s+������� �������%s+����������\n', '')
		for line in string.gmatch(text, '[^\n]+') do
			local nick, id, lvl, dist = string.match(line, '(%w+_%w+)%((%d+)%)%s+(%d) �������%s+%[(.+)%]')
			if nick and id and lvl and dist then
				if dist:find('� ���������') then
					dist = '� ����'
				end
				table.insert(wanted_new, {nick = nick, id = id, lvl = lvl, dist = dist})
			end
		end
		sampSendDialogResponse(dialogid, 1, 999999, 0)
		return false
	end

end
function sampev.onPlayerChatBubble(player_id, color, distance, duration, message)
	if message:find(" (.+) ������ ������� ��� ������ ����������") then
		local nick = message:match(' (.+) ������ ������� ��� ������ ����������')
		local result, handle = sampGetCharHandleBySampPlayerId(sampGetPlayerIdByNickname(nick))
		if result then
			local x, y, z = getCharCoordinates(handle)
			local mx, my, mz = getCharCoordinates(PLAYER_PED)
			local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
			sampAddChatMessage('[Justice Helper] {ffffff}��������! ����� ' .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. '] ���������� ������� � �������� ���������� ���������!', message_color)
		end
	end
end
addEventHandler('onReceivePacket', function (id, bs)
	if id == 220 then
		local id = raknetBitStreamReadInt8(bs)
        local cmd = raknetBitStreamReadInt8(bs)
		if cmd == 153 then
			local carId = raknetBitStreamReadInt16(bs)
			raknetBitStreamIgnoreBits(bs, 8) -- unknown byte
		
			local numberlen = raknetBitStreamReadInt8(bs) -- plate data
			raknetBitStreamIgnoreBits(bs, 24)
			local number = raknetBitStreamReadString(bs, numberlen)
		
			local typelen = raknetBitStreamReadInt8(bs) -- plate type
			raknetBitStreamIgnoreBits(bs, 24)
			local numType = raknetBitStreamReadString(bs, typelen)
			
			cache[carId] = plate.new(carId, number, numType)
		end
	end
end)
addEventHandler('onReceiveRpc', function (id, bs)
	if id == 123 then
        local carId = raknetBitStreamReadInt16(bs)
        local numLen = raknetBitStreamReadInt8(bs)
		local number = raknetBitStreamReadString(bs, numLen)
		cache[carId] = plate.new(carId, number, "gtasa_samp")
	end
end)
imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = ni
	if isMonetLoader() then
		fa.Init(14 * settings.general.custom_dpi)
	else
		fa.Init()
	end
	if settings.general.moonmonet_theme_enable and monet_no_errors then
		apply_moonmonet_theme()
	else 
		apply_dark_theme()
	end
end)
function change_dpi()
	if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
end
function give_rank()
	local command_find = false
			for _, command in ipairs(commands.commands_manage) do
				if command.enable and command.text:find('/giverank {arg_id}') then
					command_find = true
					local modifiedText = command.text
					local wait_tag = false
					local arg_id = player_id
					modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
					modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
					modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
					modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
					lua_thread.create(function()
						isActiveCommand = true
						if isMonetLoader() and settings.general.mobile_stop_button then
							sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[Justice Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
						end
						local lines = {}
						for line in string.gmatch(modifiedText, "[^&]+") do
							table.insert(lines, line)
						end
						for _, line in ipairs(lines) do 
							if command_stop then 
								command_stop = false 
								isActiveCommand = false
								if isMonetLoader() and settings.general.mobile_stop_button then
									CommandStopWindow[0] = false
								end
								sampAddChatMessage('[Justice Helper] {ffffff}��������� ������� /' .. command.cmd .. " ������� �����������!", message_color) 
								return 
							end
							if wait_tag then
								for tag, replacement in pairs(tagReplacements) do
									if line:find("{" .. tag .. "}") then
										local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
										if success then
											line = result
										end
									end
								end
								sampSendChat(line)
								wait(1500)	
							end
							if not wait_tag then
								if line == '{show_rank_menu}' then
									wait_tag = true
								end
							end
						end
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
					end)
				end
			end
			if not command_find then
				sampAddChatMessage('[Justice Helper] {ffffff}���� ��� ��������� ����� ����������� ���� ��������!', message_color)
				sampAddChatMessage('[Justice Helper] {ffffff}���������� �������� ��������� �������!', message_color)
				sampSendChat('/giverank ' .. player_id .. " " .. giverank[0])
			end
end

imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. " Justice Helper##main", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
		if imgui.BeginTabBar('���') then	
			if imgui.BeginTabItem(fa.HOUSE..u8' ������� ����') then
				if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 169 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.USER_NURSE .. u8' ���������� ��� ����������')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"��� � �������:")
					imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.name_surname))
					imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##name_surname') then
						settings.player_info.name_surname = TranslateNick(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
						input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
						save_settings()
						imgui.OpenPopup(fa.USER_NURSE .. u8' ��� � �������##name_surname')
					end
					if imgui.BeginPopupModal(fa.USER_NURSE .. u8' ��� � �������##name_surname', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##name_surname', input_name_surname, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.name_surname = u8:decode(ffi.string(input_name_surname))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"���:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.sex))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##sex') then
						if settings.player_info.sex == '����������' then
							settings.player_info.sex = '�������'
							save_settings()
						elseif settings.player_info.sex == '�������' then
							settings.player_info.sex = '�������'
							save_settings()
						elseif settings.player_info.sex == '�������' then
							settings.player_info.sex = '�������'
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"������:")
					imgui.NextColumn()
					if checkbox_accent_enable[0] then
						imgui.CenterColumnText(u8(settings.player_info.accent))
					else 
						imgui.CenterColumnText(u8'���������')
					end
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##accent') then
						imgui.OpenPopup(fa.USER_NURSE .. u8' ������ ���������##accent')
					end
					if imgui.BeginPopupModal(fa.USER_NURSE .. u8' ������ ���������##accent', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						change_dpi()
						if imgui.Checkbox('##checkbox_accent_enable', checkbox_accent_enable) then
							settings.general.accent_enable = checkbox_accent_enable[0]
							save_settings()
						end
						imgui.SameLine()
						imgui.PushItemWidth(375 * settings.general.custom_dpi)
						imgui.InputText(u8'##accent_input', input_accent, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then 
							settings.player_info.accent = u8:decode(ffi.string(input_accent))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"�����������:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##fraction') then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"��� �����������:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_tag))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##fraction_tag') then
						imgui.OpenPopup(fa.BUILDING_SHIELD .. u8' ��� �����������##fraction_tag')
					end
					if imgui.BeginPopupModal(fa.BUILDING_SHIELD .. u8' ��� �����������##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##input_fraction_tag', input_fraction_tag, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction_tag = u8:decode(ffi.string(input_fraction_tag))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"��������� � �����������:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_rank) .. " (" .. settings.player_info.fraction_rank_number .. ")")
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8"��������##rank") then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
				
				imgui.EndChild()
				end
				if imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 98 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.SITEMAP .. u8' �������������� ������� �������')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"�������������� ����")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"����������� �� ������ ������� � �����������")
					end
					imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
					imgui.NextColumn()
					if settings.general.use_info_menu then
						imgui.CenterColumnText(u8'��������')
					else
						imgui.CenterColumnText(u8'���������')
					end
					imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
					imgui.NextColumn()
					if settings.general.use_info_menu then
						if imgui.CenterColumnSmallButton(u8'���������##info_menu') then
							settings.general.use_info_menu = false
							InformationWindow[0] = false
							save_settings()
						end
						else
						if imgui.CenterColumnSmallButton(u8'��������##info_menu') then
							settings.general.use_info_menu = true
							InformationWindow[0] = true
							save_settings()
						end
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"����� RP ��������� ������")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"��� �������������/������� ������ � ���� ����� RP ���������.")
					end
					imgui.NextColumn()
					if settings.general.rp_gun then
						imgui.CenterColumnText(u8'��������')
					else
						imgui.CenterColumnText(u8'���������')
					end
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'���������##rp_gun') then
						imgui.OpenPopup(fa.GUN .. u8' ��������� RP ������##weapon_name')
					end
					if imgui.BeginPopupModal(fa.GUN .. u8' ��������� RP ������##weapon_name', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
						change_dpi()
						if imgui.Button((settings.general.rp_gun and u8'���������##rp_gun' or u8'��������##rp_gun'), imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.general.rp_gun = not settings.general.rp_gun
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.GEAR .. u8' �������� RP ����', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							RPWeaponWindow[0] = true
							if not settings.general.rp_gun then
								settings.general.rp_gun = true
								save_settings()
							end
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"����� RP ������� � �����")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"��� ���� ��������� ����� � ��������� ����� � � ������ � �����.\n�������� � ������� ���� � � ��������� �� ��������:\n/r /m /s /do")
					end
					imgui.NextColumn()
					if settings.general.rp_chat then
						imgui.CenterColumnText(u8'��������')
					else
						imgui.CenterColumnText(u8'���������')
					end
					imgui.NextColumn()
					if settings.general.rp_chat then
						if imgui.CenterColumnSmallButton(u8'���������##rp_chat') then
							settings.general.rp_chat = false
							save_settings()
						end
						else
						if imgui.CenterColumnSmallButton(u8'��������##rp_chat') then
							settings.general.rp_chat = true
							save_settings()
						end
					end
					imgui.Columns(1)
				imgui.EndChild()
				end
				if imgui.BeginChild('##4', imgui.ImVec2(589 * settings.general.custom_dpi, 28 * settings.general.custom_dpi), true) then
					imgui.Columns(2)
					imgui.SetCursorPosX((imgui.GetWindowWidth() - 150) * 0.5)
					imgui.Text(fa.CHECK .. u8" Rebuild by Varionchik " .. fa.CHECK)
					imgui.SetColumnWidth(-1, 480 * settings.general.custom_dpi)
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8' ������� � ���������') then 
				if imgui.BeginTabBar('Tabs2') then
					if imgui.BeginTabItem(fa.BARS..u8' ����������� �������') then 
						if imgui.BeginChild('##99', imgui.ImVec2(589 * settings.general.custom_dpi, 333 * settings.general.custom_dpi), true) then
							imgui.Columns(2)
							imgui.CenterColumnText(u8"�������")
							imgui.SetColumnWidth(-1, 220 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"��������")
							imgui.SetColumnWidth(-1, 400 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/jm")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���� �������������� � �������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/mb")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���� ����������� /members")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/wanteds")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���� ������ ������ /wanted")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/dep")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���� ����� ������������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/patrool")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���� ��������������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/sob")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���� ���������� �������������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/sum")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���� ����� ������ �������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/tsm")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���� ����� ������ �������")
							imgui.Columns(1)
							imgui.Separator()
							
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/afind")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������ /find ��� ������ ������ �� ID")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/awanted")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����-����� ������� � �������� ����� ���")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/pnv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������/����� ���� ������� �������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/irv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������/����� ����������� ����")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/stop")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������������� ��������� ����� RP �������")
							imgui.Columns(1)
							imgui.EndChild()
						end
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP ������� (�����)') then 
						if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 303 * settings.general.custom_dpi), true) then
							imgui.Columns(3)
							imgui.CenterColumnText(u8"�������")
							imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"��������")
							imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"��������")
							imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/maska")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������/����� ���������")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����������")
							imgui.Columns(1)
							imgui.Separator()
							for index, command in ipairs(commands.commands) do
								imgui.Columns(3)
								if command.enable then
									imgui.CenterColumnText('/' .. u8(command.cmd))
									imgui.NextColumn()
									imgui.CenterColumnText(u8(command.description))
									imgui.NextColumn()
								else
									imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
									imgui.NextColumn()
									imgui.CenterColumnTextDisabled(u8(command.description))
									imgui.NextColumn()
								end
								imgui.Text(' ')
								imgui.SameLine()
								if command.enable then
									if imgui.SmallButton(fa.TOGGLE_ON .. '##'..command.cmd) then
										command.enable = not command.enable
										save_commands()
										sampUnregisterChatCommand(command.cmd)
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8"���������� ������� /"..command.cmd)
									end
								else
									if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
										command.enable = not command.enable
										save_commands()
										register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
									end
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
				
									if command.arg == '' then
										ComboTags[0] = 0
									elseif command.arg == '{arg}' then	
										ComboTags[0] = 1
									elseif command.arg == '{arg_id}' then
										ComboTags[0] = 2
									elseif command.arg == '{arg_id} {arg2}' then
										ComboTags[0] = 3
									elseif command.arg == '{arg_id} {arg2} {arg3}' then
										ComboTags[0] = 4
									end

									binder_data = {change_waiting = command.waiting, change_cmd = command.cmd, change_text = command.text:gsub('&', '\n'), change_arg = command.arg, change_bind = command.bind, change_in_fastmenu = command.in_fastmenu, create_command_9_10 = false}

									input_description = imgui.new.char[256](u8(command.description))
									input_cmd = imgui.new.char[256](u8(command.cmd))
									input_text = imgui.new.char[8192](u8(binder_data.change_text))
									waiting_slider = imgui.new.float(tonumber(command.waiting))	

									BinderWindow[0] = true
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
									imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##' .. command.cmd)
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"�������� ������� /"..command.cmd)
								end
								if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
									change_dpi()
									imgui.CenterText(u8'�� ������������� ������ ������� ������� /' .. u8(command.cmd) .. '?')
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										sampUnregisterChatCommand(command.cmd)
										table.remove(commands.commands, index)
										save_commands()
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
								imgui.Columns(1)
								imgui.Separator()
							end
							imgui.EndChild()
						end
						if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������##new_cmd',imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							if #commands.commands >= 50 then
								for i = 1, 10, 1 do
									sampAddChatMessage('[Justice Helper] {ffffff}����� FREE ������ �� 50 ������, ������ � ������� ������ �������! �������� � MTG MODS', message_color)
								end
							else
								local new_cmd = {cmd = '', description = '', text = '', arg = '', enable = true, waiting = '1.500', bind = "{}" }
								table.insert(commands.commands, new_cmd)

								binder_data = {change_waiting = new_cmd.waiting, change_cmd = new_cmd.cmd, change_text = new_cmd.text, change_arg = new_cmd.arg, change_bind = new_cmd.bind, change_in_fastmenu = false, create_command_9_10 = false}

								ComboTags[0] = 0
								input_description = imgui.new.char[256]("")
								input_cmd = imgui.new.char[256]("")
								input_text = imgui.new.char[8192]("")
								waiting_slider = imgui.new.float(1.500)

								BinderWindow[0] = true
							end

							

						end
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP ������� (��� 9/10)') then 
						if tonumber(settings.player_info.fraction_rank_number) >= 1 then
							if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 303 * settings.general.custom_dpi), true) then
								imgui.Columns(3)
								imgui.CenterColumnText(u8"�������")
								imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
								imgui.NextColumn()
								imgui.CenterColumnText(u8"��������")
								imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
								imgui.NextColumn()
								imgui.CenterColumnText(u8"��������")
								imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8"�������������� ����")
								imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"������� ������ ��� ������ ��� ��� ������������!\n��������� ������������� ��������� ��� ��� ������ ���\n� ������������� �� ������, ���� �������� ��������� � /rb")
								end
								imgui.NextColumn()
								if settings.general.auto_uval then
									imgui.CenterColumnText(u8'��������')
								else
									imgui.CenterColumnText(u8'���������')
								end
								imgui.NextColumn()
								if settings.general.auto_uval then
									if imgui.CenterColumnSmallButton(u8'���������##auto_uval') then
										settings.general.auto_uval = false
										save_settings()
									end
								else
									if imgui.CenterColumnSmallButton(u8'��������##auto_uval') then
										if tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then 
											settings.general.auto_uval = true
											save_settings()
										else
											settings.general.auto_uval = false
											sampAddChatMessage('[Justice Helper] {ffffff}��� ������� �������� ������ ������ � ������������!',message_color)
										end
									end
								end
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/spcar")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"���������� ���������� �����������")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"����������")
								imgui.Columns(1)
								imgui.Separator()	
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/jlm")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"������� ������� ���� ���������� �������")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"����������")
								imgui.Columns(1)
								imgui.Separator()	
								for index, command in ipairs(commands.commands_manage) do
									imgui.Columns(3)
									if command.enable then
										imgui.CenterColumnText('/' .. u8(command.cmd))
										imgui.NextColumn()
										imgui.CenterColumnText(u8(command.description))
										imgui.NextColumn()
									else
										imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
										imgui.NextColumn()
										imgui.CenterColumnTextDisabled(u8(command.description))
										imgui.NextColumn()
									end
									imgui.Text('  ')
									imgui.SameLine()
									if command.enable then
										if imgui.SmallButton(fa.TOGGLE_ON .. '##'..command.cmd) then
											command.enable = not command.enable
											save_commands()
											sampUnregisterChatCommand(command.cmd)
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"���������� ������� /"..command.cmd)
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
											command.enable = not command.enable
											save_commands()
											register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
										end
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
										if command.arg == '' then
											ComboTags[0] = 0
										elseif command.arg == '{arg}' then	
											ComboTags[0] = 1
										elseif command.arg == '{arg_id}' then
											ComboTags[0] = 2
										elseif command.arg == '{arg_id} {arg2}' then
											ComboTags[0] = 3
										elseif command.arg == '{arg_id} {arg2} {arg3}' then
											ComboTags[0] = 4
										end

										binder_data = {change_waiting = command.waiting, change_cmd = command.cmd, change_text = command.text:gsub('&', '\n'), change_arg = command.arg, change_bind = command.bind, change_in_fastmenu = command.in_fastmenu, create_command_9_10 = true}


										input_description = imgui.new.char[256](u8(command.description))
										input_cmd = imgui.new.char[256](u8(command.cmd))
										input_text = imgui.new.char[8192](u8(binder_data.change_text))
										waiting_slider = imgui.new.float(tonumber(command.waiting))	

										
										BinderWindow[0] = true
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
										imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##9-10' .. command.cmd)
									end
									if imgui.IsItemHovered() then	
										imgui.SetTooltip(u8"�������� ������� /"..command.cmd)
									end
									if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##9-10' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
										change_dpi()
										imgui.CenterText(u8'�� ������������� ������ ������� ������� /' .. u8(command.cmd) .. '?')
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											sampUnregisterChatCommand(command.cmd)
											table.remove(commands.commands_manage, index)
											save_commands()
											imgui.CloseCurrentPopup()
										end
										imgui.End()
									end
									imgui.Columns(1)
									imgui.Separator()
								end
								imgui.EndChild()
							end
							if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������##new_cmd_9-10', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							

								if #commands.commands_manage >= 15 then
									for i = 1, 10, 1 do
										sampAddChatMessage('[Justice Helper] {ffffff}����� FREE ������ �� 15 �����.������, ������ � ������� ������ �������! �������� � MTG MODS', message_color)
									end
								else
									local new_cmd = {cmd = '', description = '', text = '', arg = '', enable = true, waiting = '1.500', bind = "{}" }
									table.insert(commands.commands_manage, new_cmd)

									binder_data = {change_waiting = new_cmd.waiting, change_cmd = new_cmd.cmd, change_text = new_cmd.text, change_arg = new_cmd.arg, change_bind = new_cmd.bind, change_in_fastmenu = false, create_command_9_10 = true}

									ComboTags[0] = 0
									input_description = imgui.new.char[256](u8(""))
									input_cmd = imgui.new.char[256](u8(""))
									input_text = imgui.new.char[8192](u8(binder_data.change_text))
									waiting_slider = imgui.new.float(1.500)	

									BinderWindow[0] = true
								end
								
							end
						else
							imgui.CenterText(fa.TRIANGLE_EXCLAMATION)
							imgui.Separator()
							imgui.CenterText(u8"� ��� ��� ������� � ������ ��������!")
							imgui.CenterText(u8"���������� ����� 9 ��� 10 ����, � ��� �� "..settings.player_info.fraction_rank_number..u8" ����!")
							imgui.Separator()
						end
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.BARS..u8' ���. �������') then 
						if imgui.BeginChild('##999', imgui.ImVec2(589 * settings.general.custom_dpi, 333 * settings.general.custom_dpi), true) then
							if isMonetLoader() then
								if imgui.Checkbox(u8(' ����������� ������ "��������������" (������ /jm ID)'), checkbox_mobile_fastmenu_button) then
									settings.general.mobile_fastmenu_button = checkbox_mobile_fastmenu_button[0]
									FastMenuButton[0] = checkbox_mobile_fastmenu_button[0]
									save_settings()
								end
								if imgui.Checkbox(u8(' ����������� ������ "����������" (������ /stop)'), checkbox_mobile_stop_button) then
									settings.general.mobile_stop_button = checkbox_mobile_stop_button[0]
									save_settings()
								end
								if imgui.Checkbox(u8(' ����������� ������ "55/66" (������ /meg)'), checkbox_mobile_meg_button) then
									settings.general.mobile_meg_button = checkbox_mobile_meg_button[0]
									MegafonWindow[0] = settings.general.mobile_meg_button
									save_settings()
								end
								if imgui.Checkbox(u8(' ����������� ������ "Taser"'), checkbox_mobile_taser_button) then
									settings.general.use_taser_menu = checkbox_mobile_taser_button[0]
									TaserWindow[0] = settings.general.use_taser_menu
									save_settings()
								end
							else
								imgui.CenterText(fa.KEYBOARD .. u8(' Hotkeys'))
								imgui.CenterText(u8('������������ ������������ ������� (�����) ������ ������� ����� �������'))
								imgui.CenterText(u8' ����������������� Hotkeys:')
								imgui.SameLine()
								if hotkey_no_errors then
									if settings.general.use_binds then
										if imgui.SmallButton(fa.TOGGLE_ON .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"��������� ������� ������")
										end
										if settings.general.use_binds and hotkey_no_errors then
											imgui.Separator()
											imgui.CenterText(u8'�������� �������� ���� ������� (������ /jh):')
											local width = imgui.GetWindowWidth()
											local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_mainmenu))
											imgui.SetCursorPosX( width / 2 - calc.x / 2 )
											if MainMenuHotKey:ShowHotKey() then
												settings.general.bind_mainmenu = encodeJson(MainMenuHotKey:GetHotKey())
												save_settings()
											end
											imgui.Separator()
											imgui.CenterText(u8'�������� �������� ���� �������������� � ������� (������ /jm):')
											imgui.CenterText(u8'��������� �� ������ ����� ��� � ������')
											local width = imgui.GetWindowWidth()
											local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_fastmenu))
											imgui.SetCursorPosX(width / 2 - calc.x / 2)
											if FastMenuHotKey:ShowHotKey() then
												settings.general.bind_fastmenu = encodeJson(FastMenuHotKey:GetHotKey())
												save_settings()
											end
											imgui.Separator()
											imgui.CenterText(u8'�������� �������� ���� ���������� ������� (������ /jlm):')
											imgui.CenterText(u8'��������� �� ������ ����� ��� � ������')
											local width = imgui.GetWindowWidth()
											local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_leader_fastmenu))
											imgui.SetCursorPosX(width / 2 - calc.x / 2)
											if LeaderFastMenuHotKey:ShowHotKey() then
												settings.general.bind_leader_fastmenu = encodeJson(LeaderFastMenuHotKey:GetHotKey())
												save_settings()
											end
											imgui.Separator()
											imgui.CenterText(u8'������������� ��������� ������� (������ /stop):')
											local width = imgui.GetWindowWidth()
											local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_command_stop))
											imgui.SetCursorPosX(width / 2 - calc.x / 2)
											if CommandStopHotKey:ShowHotKey() then
												settings.general.bind_command_stop = encodeJson(CommandStopHotKey:GetHotKey())
												save_settings()
											end
											imgui.Separator()
											imgui.CenterText(u8'��������� ����� ������� ��� ������ RP ������� � ������� �������������� �������')
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"�������� ������� ������")
										end
										imgui.Separator()
										imgui.CenterText(u8'������� ������� (������) ���������!')
									end
									
								else
									imgui.SameLine()
									imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds')
									imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8' ������: ���������� ����� ����������!')
								end
								
								if imgui.BeginPopupModal(fa.KEYBOARD .. u8' ��������� ������', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
									imgui.SetWindowSizeVec2(imgui.ImVec2(600 * settings.general.custom_dpi, 415	* settings.general.custom_dpi))
									change_dpi()
									
									imgui.End()
								end
							end
							imgui.EndChild()
						end
						
						
					imgui.EndTabItem() 
				end
				imgui.EndTabBar() 
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.STAR .. u8' ������ � ������') then 
				if imgui.BeginChild('##smartuk', imgui.ImVec2(292 * settings.general.custom_dpi, 340 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.STAR .. u8' ������� ������ �������')
					imgui.Separator()
					imgui.SetCursorPosY(100 * settings.general.custom_dpi)
					imgui.SetCursorPosX(105 * settings.general.custom_dpi)
					if imgui.Button(fa.DOWNLOAD .. u8' ��������� ##smartuk') then
						download_smartuk = true
						downloadFileFromUrlToPath('https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/SmartUK/' .. getARZServerNumber() .. '/SmartUK.json', path_uk)
						imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##donwloadsmartuk')
					end
					if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##donwloadsmartuk', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
						if download_smartuk then
							change_dpi()
							imgui.CenterText(u8'��� ���������� ������ ������� ��� ������� ' .. getARZServerName(getARZServerNumber()) .. "[" .. getARZServerNumber() .. ']')
							imgui.CenterText(u8'����� �������� �������� ������� ������� � �� ������� ��������� � ���� ��� ����������.')
							imgui.Separator()
							imgui.CenterText(u8'���� ������ ������ 10 ������ � ������ �� ����������, ������ ��������� ������ ����������!')
							imgui.CenterText(u8'������� ������� ������ ��������������� ���������� ������ �������:')
							imgui.CenterText(u8'1) �� ������ ������� ��������� ������ �� ������ "���������������"')
							imgui.CenterText(u8'2) �� ������ ������� ������� ������ ������� �� ������ (������) � �������� ��� �� �� ����:')
							imgui.CenterText(u8(path_uk))
							imgui.Separator()
						else
							MainWindow[0] = false
							imgui.CloseCurrentPopup()
						end
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_PLAY .. u8' ������� ������', imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							openLink('https://github.com/MTGMODS/lua_scripts/tree/main/justice-helper/SmartUK/')
							MainWindow[0] = false
						end
						imgui.EndPopup()
					end
					imgui.SetCursorPosX(80 * settings.general.custom_dpi)
					imgui.SetCursorPosY(170 * settings.general.custom_dpi)
					if imgui.Button(fa.PEN_TO_SQUARE .. u8' ��������������� ##smartuk') then
						imgui.OpenPopup(fa.STAR .. u8' ������� ������ �������##smartuk')
					end
					if imgui.BeginPopupModal(fa.STAR .. u8' ������� ������ �������##smartuk', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
						change_dpi()
						imgui.BeginChild('##smartukedit', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true)
						for chapter_index, chapter in ipairs(smart_uk) do
							imgui.Columns(2)
							imgui.BulletText(u8(chapter.name))
							imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
							imgui.NextColumn()
							if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index) then
								imgui.OpenPopup(u8(chapter.name).. '##' .. chapter_index)
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index) then
								imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##' .. chapter_index)
							end
							if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##' .. chapter_index, _, imgui.WindowFlags.NoResize ) then
								change_dpi()
								imgui.CenterText(u8'�� ������������� ������ ������� �����?')
								imgui.CenterText(u8(chapter.name))
								imgui.Separator()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									table.remove(smart_uk, chapter_index)
									save_smart_uk()
									imgui.CloseCurrentPopup()
								end
								imgui.End()
							end
							imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
							imgui.Columns(1)
							if imgui.BeginPopupModal(u8(chapter.name) .. '##' .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
								change_dpi()
								if imgui.BeginChild('##smartukedititem', imgui.ImVec2(589 * settings.general.custom_dpi, 390 * settings.general.custom_dpi), true) then
									if chapter.item then
										for index, item in ipairs(chapter.item) do
											imgui.Columns(2)
											imgui.BulletText(u8(item.text))
											imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
											imgui.NextColumn()
											if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index .. '##' .. index) then
												input_smartuk_text = imgui.new.char[256](u8(item.text))
												input_smartuk_lvl = imgui.new.char[256](u8(item.lvl))
												input_smartuk_reason = imgui.new.char[256](u8(item.reason))
												imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8(" �������������� ���������##") .. chapter.name .. index .. chapter_index)
											end
											if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8(" �������������� ���������##") .. chapter.name .. index .. chapter_index, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
												change_dpi()
												if imgui.BeginChild('##smartukedititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
													imgui.CenterText(u8'�������� ���������:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartuk_text', input_smartuk_text, 256)
													imgui.CenterText(u8'������� ������� ��� ������ (�� 1 �� 6):')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartuk_lvl', input_smartuk_lvl, 256)
													imgui.CenterText(u8'������� ��� ������ �������:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartuk_reason', input_smartuk_reason, 256)
													imgui.EndChild()
												end	
												if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													if u8:decode(ffi.string(input_smartuk_lvl)) ~= '' and not u8:decode(ffi.string(input_smartuk_lvl)):find('%D') and tonumber(u8:decode(ffi.string(input_smartuk_lvl))) >= 1 and tonumber(u8:decode(ffi.string(input_smartuk_lvl))) <= 6 and u8:decode(ffi.string(input_smartuk_text)) ~= '' and u8:decode(ffi.string(input_smartuk_reason)) ~= '' then
														item.text = u8:decode(ffi.string(input_smartuk_text))
														item.lvl = u8:decode(ffi.string(input_smartuk_lvl))
														item.reason = u8:decode(ffi.string(input_smartuk_reason))
														save_smart_uk()
														imgui.CloseCurrentPopup()
													else
														sampAddChatMessage('[Justice Helper] {ffffff}������ � ��������� ������, ���������!', message_color)
													end
												end
												imgui.EndPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index .. '##' .. index) then
												imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##' .. chapter_index .. '##' .. index)
											end
											if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##' .. chapter_index .. '##' .. index, _, imgui.WindowFlags.NoResize ) then
												change_dpi()
												imgui.CenterText(u8'�� ������������� ������ ������� ��������?')
												imgui.CenterText(u8(item.text))
												imgui.Separator()
												if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													table.remove(chapter.item, index)
													save_smart_uk()
													imgui.CloseCurrentPopup()
												end
												imgui.End()
											end
											imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
											imgui.Columns(1)
											imgui.Separator()
										end
									end
									imgui.EndChild()
								end
								if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ����� ��������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									input_smartuk_text = imgui.new.char[8192](u8(''))
									input_smartuk_lvl = imgui.new.char[256](u8(''))
									input_smartuk_reason = imgui.new.char[8192](u8(''))
									imgui.OpenPopup(fa.CIRCLE_PLUS .. u8(' ���������� ������ ���������'))
								end
								if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8(' ���������� ������ ���������'), _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
									if imgui.BeginChild('##smartukedititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
										imgui.CenterText(u8'�������� ���������:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartuk_text', input_smartuk_text, 8192)
										imgui.CenterText(u8'������� ������� ��� ������ (�� 1 �� 6):')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartuk_lvl', input_smartuk_lvl, 256)
										imgui.CenterText(u8'������� ��� ������ �������:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartuk_reason', input_smartuk_reason, 8192)
										imgui.EndChild()
									end	
									if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										local text = u8:decode(ffi.string(input_smartuk_text))
										local lvl = u8:decode(ffi.string(input_smartuk_lvl))
										local reason = u8:decode(ffi.string(input_smartuk_reason))
										if lvl ~= '' and not tostring(lvl):find('%D') and tonumber(lvl) >= 1 and tonumber(lvl) <= 6 and text ~= '' and reason ~= '' then
											local temp = { text = text, lvl = lvl, reason = reason }
											table.insert(chapter.item, temp)
											save_smart_uk()
											imgui.CloseCurrentPopup()
										else
											sampAddChatMessage('[Justice Helper] {ffffff}������ � ��������� ������, ���������!', message_color)
										end
									end
									imgui.EndPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.EndPopup()
							end
							imgui.Separator()
						end
						imgui.EndChild()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������� �����', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							input_smartuk_name = imgui.new.char[8192](u8(''))
							imgui.OpenPopup(fa.CIRCLE_PLUS .. u8' ���������� ������ ������')
						end
						if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8' ���������� ������ ������', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
							imgui.CenterText(u8('������� ��������/����� ������ � ������� "���������"'))
							imgui.PushItemWidth(500 * settings.general.custom_dpi)
							imgui.InputText(u8'##input_smartuk_name', input_smartuk_name, 8192)
							imgui.CenterText(u8'�������� ��������, �� �� ������� �������� ��� � ����������!')
							if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.CIRCLE_PLUS .. u8' ��������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								local temp = u8:decode(ffi.string(input_smartuk_name))
								local new_chapter = { name = temp, item = {} }
								table.insert(smart_uk, new_chapter)
								save_smart_uk()
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SetCursorPosY(250 * settings.general.custom_dpi)
					imgui.CenterText(u8('�������������: /sum [ID ������]'))
					
					imgui.EndChild()
				end
				imgui.SameLine()
				if imgui.BeginChild('##smartpdd', imgui.ImVec2(292 * settings.general.custom_dpi, 340 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.TICKET .. u8' ������� ������ ������')
					imgui.Separator()
					imgui.SetCursorPosY(105 * settings.general.custom_dpi)
					imgui.SetCursorPosX(105 * settings.general.custom_dpi)
					if imgui.Button(fa.DOWNLOAD .. u8' ��������� ##smartpdd') then
						download_smartpdd = true
						downloadFileFromUrlToPath('https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/SmartPDD/' .. getARZServerNumber() .. '/SmartPDD.json', path_pdd)
						imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##donwloadsmartpdd')
					end
					if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##donwloadsmartpdd', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
						if download_smartpdd then
							change_dpi()
							imgui.CenterText(u8'��� ���������� ����� ������� ��� ������� ' .. getARZServerName(getARZServerNumber()) .. "[" .. getARZServerNumber() .. ']')
							imgui.CenterText(u8'����� �������� �������� ������� ������� � �� ������� ��������� � ���� ��� ����������.')
							imgui.Separator()
							imgui.CenterText(u8'���� ������ ������ 10 ������ � ������ �� ����������, ������ ��������� ������ ����������!')
							imgui.CenterText(u8'������� ������� ������ ��������������� ���������� ������ �������:')
							imgui.CenterText(u8'1) �� ������ ������� ��������� ������ �� ������ "���������������"')
							imgui.CenterText(u8'2) �� ������ ������� ������� ������ ������� �� ������ (������) � �������� ��� �� �� ����:')
							imgui.CenterText(u8(path_pdd))
							imgui.Separator()
						else
							MainWindow[0] = false
							imgui.CloseCurrentPopup()
						end
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_PLAY .. u8' ������� ������', imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							openLink('https://github.com/MTGMODS/lua_scripts/tree/main/justice-helper/SmartPDD/')
							MainWindow[0] = false
						end
						imgui.EndPopup()
					end
					imgui.SetCursorPosX(80 * settings.general.custom_dpi)
					imgui.SetCursorPosY(170 * settings.general.custom_dpi)
					if imgui.Button(fa.PEN_TO_SQUARE .. u8' ��������������� ##smartpdd') then
						imgui.OpenPopup(fa.TICKET .. u8' ������� ����� �������##smartpdd')
					end
					if imgui.BeginPopupModal(fa.TICKET .. u8' ������� ����� �������##smartpdd', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
						change_dpi()
						imgui.BeginChild('##smartpddedit', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true)
						for chapter_index, chapter in ipairs(smart_pdd) do
							imgui.Columns(2)
							imgui.BulletText(u8(chapter.name))
							imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
							imgui.NextColumn()
							if imgui.Button(fa.PEN_TO_SQUARE .. '##smartpdd' .. chapter_index) then
								imgui.OpenPopup(u8(chapter.name).. '##smartpdd' .. chapter_index)
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. '##smartpdd' .. chapter_index) then
								imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##smartpdd' .. chapter_index)
							end
							if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##smartpdd' .. chapter_index, _, imgui.WindowFlags.NoResize ) then
								change_dpi()
								imgui.CenterText(u8'�� ������������� ������ ������� �����?')
								imgui.CenterText(u8(chapter.name))
								imgui.Separator()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									table.remove(smart_pdd, chapter_index)
									save_smart_pdd()
									imgui.CloseCurrentPopup()
								end
								imgui.End()
							end
							imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
							imgui.Columns(1)
							if imgui.BeginPopupModal(u8(chapter.name).. '##smartpdd' .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
								change_dpi()
								if imgui.BeginChild('##smartpddedititem', imgui.ImVec2(589 * settings.general.custom_dpi, 390 * settings.general.custom_dpi), true) then
									if chapter.item then
										for index, item in ipairs(chapter.item) do
											imgui.Columns(2)
											imgui.BulletText(u8(item.text))
											imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
											imgui.NextColumn()
											if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index .. '##smartpdd' .. index) then
												input_smartpdd_text = imgui.new.char[8192](u8(item.text))
												input_smartpdd_amount = imgui.new.char[256](u8(item.amount))
												input_smartpdd_reason = imgui.new.char[256](u8(item.reason))
												imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8(" �������������� ���������##smartpdd") .. chapter.name .. index .. chapter_index)
											end
											if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8(" �������������� ���������##smartpdd") .. chapter.name .. index .. chapter_index, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
												change_dpi()
												if imgui.BeginChild('##smartpddedititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
													imgui.CenterText(u8'�������� ���������:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartpdd_text', input_smartpdd_text, 8192)
													imgui.CenterText(u8'����� ������ (����� ��� ����� ���� ��������):')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartpdd_amount', input_smartpdd_amount, 256)
													imgui.CenterText(u8'������� ��� ������ ������:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartpdd_reason', input_smartpdd_reason, 256)
													imgui.EndChild()
												end	
												if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													if u8:decode(ffi.string(input_smartpdd_amount)) ~= ''and u8:decode(ffi.string(input_smartpdd_text)) ~= '' and u8:decode(ffi.string(input_smartpdd_reason)) ~= '' and u8:decode(ffi.string(input_smartpdd_amount)):find('%d') and not u8:decode(ffi.string(input_smartpdd_amount)):find('%D') then
														item.text = u8:decode(ffi.string(input_smartpdd_text))
														item.amount = u8:decode(ffi.string(input_smartpdd_amount))
														item.reason = u8:decode(ffi.string(input_smartpdd_reason))
														save_smart_pdd()
														imgui.CloseCurrentPopup()
													else
														sampAddChatMessage('[Justice Helper] {ffffff}������ � ��������� ������, ���������!', message_color)
													end
												end
												imgui.EndPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index .. '###smartpdd' .. index) then
												imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##smartpdd' .. chapter_index .. '##' .. index)
											end
											if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##smartpdd' .. chapter_index .. '##' .. index, _, imgui.WindowFlags.NoResize ) then
												change_dpi()
												imgui.CenterText(u8'�� ������������� ������ ������� ��������?')
												imgui.CenterText(u8(item.text))
												imgui.Separator()
												if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													table.remove(chapter.item, index)
													save_smart_pdd()
													imgui.CloseCurrentPopup()
												end
												imgui.End()
											end
											imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
											imgui.Columns(1)
											imgui.Separator()
										end
									end
									imgui.EndChild()
								end
								if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ����� ��������##smartpdd', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									input_smartpdd_text = imgui.new.char[8192](u8(''))
									input_smartpdd_amount = imgui.new.char[256](u8(''))
									input_smartpdd_reason = imgui.new.char[8192](u8(''))
									imgui.OpenPopup(fa.CIRCLE_PLUS .. u8(' ���������� ������ ���������##smartpdd'))
								end
								if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8(' ���������� ������ ���������##smartpdd'), _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
		
									if imgui.BeginChild('##smartpddedititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
										imgui.CenterText(u8'�������� ���������:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartpdd_text', input_smartpdd_text, 8192)
										imgui.CenterText(u8'����� ������ (����� ��� ����� ���� ��������):')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartpdd_amount', input_smartpdd_amount, 256)
										imgui.CenterText(u8'������� ��� ������ ������:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartpdd_reason', input_smartpdd_reason, 8192)
										imgui.EndChild()
									end	
									if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										local text = u8:decode(ffi.string(input_smartpdd_text))
										local amount = u8:decode(ffi.string(input_smartpdd_amount))
										local reason = u8:decode(ffi.string(input_smartpdd_reason))
										if amount ~= ''and text ~= '' and reason ~= '' and tostring(amount):find('%d') and not tostring(amount):find('%D') then
											local temp = { text = text, amount = amount, reason = reason }
											table.insert(chapter.item, temp)
											save_smart_pdd()
											imgui.CloseCurrentPopup()
										else
											sampAddChatMessage('[Justice Helper] {ffffff}������ � ��������� ������, ���������!', message_color)
										end
									end
									imgui.EndPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.EndPopup()
							end
							imgui.Separator()
						end
						imgui.EndChild()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������� �����', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							input_smartpdd_name = imgui.new.char[8192](u8(''))
							imgui.OpenPopup(fa.CIRCLE_PLUS .. u8' ���������� ������ ������##smartpdd')
						end
						if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8' ���������� ������ ������##smartpdd', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
							imgui.CenterText(u8('������� ��������/����� ������ � ������� "���������"'))
							imgui.PushItemWidth(500 * settings.general.custom_dpi)
							imgui.InputText(u8'##input_smartpdd_name', input_smartpdd_name, 8192)
							imgui.CenterText(u8'�������� ��������, �� �� ������� �������� ��� � ����������!')
							if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.CIRCLE_PLUS .. u8' ��������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								local temp = u8:decode(ffi.string(input_smartpdd_name))
								local new_chapter = { name = temp, item = {} }
								table.insert(smart_pdd, new_chapter)
								save_smart_pdd()
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SetCursorPosY(250 * settings.general.custom_dpi)
					imgui.CenterText(u8('�������������: /tsm [ID ������]'))
					imgui.EndChild()
				end	
				imgui.CenterText(u8'�������� ������/������ ��������? �������� ������� ������� �� ����� Discord �������.')
			imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.FILE_PEN..u8' �������') then 
			 	imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 330 * settings.general.custom_dpi), true)
				imgui.Columns(2)
				imgui.CenterColumnText(u8"������ ���� ����� �������/���������:")
				imgui.SetColumnWidth(-1, 495 * settings.general.custom_dpi)
				imgui.NextColumn()
				imgui.CenterColumnText(u8"��������")
				imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
				imgui.Columns(1)
				imgui.Separator()
				for i, note in ipairs(notes.note) do
					imgui.Columns(2)
					imgui.CenterColumnText(u8(note.note_name))
					imgui.NextColumn()
					if imgui.SmallButton(fa.UP_RIGHT_FROM_SQUARE .. '##' .. i) then
						show_note_name = u8(note.note_name)
						show_note_text = u8(note.note_text)
						NoteWindow[0] = true
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'������� ������� "' .. u8(note.note_name) .. '"')
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. i) then
						local note_text = note.note_text:gsub('&','\n')
						input_text_note = imgui.new.char[16384](u8(note_text))
						input_name_note = imgui.new.char[256](u8(note.note_name))
						imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' ��������� �������' .. '##' .. i)	
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'�������������� ������� "' .. u8(note.note_name) .. '"')
					end
					if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' ��������� �������' .. '##' .. i, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
						change_dpi()
						if imgui.BeginChild('##9992', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true) then	
							imgui.PushItemWidth(578 * settings.general.custom_dpi)
							imgui.InputText(u8'##note_name', input_name_note, 256)
							imgui.InputTextMultiline("##note_text", input_text_note, 16384, imgui.ImVec2(578 * settings.general.custom_dpi, 320 * settings.general.custom_dpi))
							imgui.EndChild()
						end	
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ��������� �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							note.note_name = u8:decode(ffi.string(input_name_note))
							local temp = u8:decode(ffi.string(input_text_note))
							note.note_text = temp:gsub('\n', '&')
							save_notes()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.TRASH_CAN .. '##' .. i) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##' .. i .. note.note_name)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'�������� ������� "' .. u8(note.note_name) .. '"')
					end
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##' .. i .. note.note_name, _, imgui.WindowFlags.NoResize ) then
						change_dpi()
						imgui.CenterText(u8'�� ������������� ������ ������� ������� "' .. u8(note.note_name) .. '" ?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							table.remove(notes.note, i)
							save_notes()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
				end
				imgui.EndChild()
				if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
					if #notes.note >= 5 then
						for i = 1, 10, 1 do
							sampAddChatMessage('[Justice Helper] {ffffff}����� FREE ������ �� 5 �������, ������ � ������� ������ �������! �������� � MTG MODS', message_color)
						end
					else
						local new_note = {note_name = "����� �������", note_text = "����� ����� ����� �������" }
						table.insert(notes.note, new_note)
						save_notes()
					end

				end
				
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.GEAR..u8' ���������') then 
				imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 145 * settings.general.custom_dpi), true)
				imgui.CenterText(fa.CIRCLE_INFO .. u8' �������������� ���������� ��� ������')
				imgui.Separator()
				imgui.Text(fa.CIRCLE_USER..u8" ����������� ������� �������: Varionov")
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO..u8" ������������� ������ �������: Rebuild Free")
				imgui.SameLine()
				if imgui.SmallButton(u8'��������� ����������') then
					check_update()
				end
				imgui.Text("")
				imgui.Text(fa.CIRCLE_INFO..u8" ������ ������ ������� ���� ������������� ���� ��� ���������� �������������")
				imgui.Text(fa.CIRCLE_INFO..u8" ���� �� �������� ������ ������, �� �� ���������� ��������� �������")
				imgui.Text("")
				imgui.Text(fa.CIRCLE_INFO..u8" ����������� ����������� ������ ������ �� ����� ��������")
				imgui.EndChild()
				imgui.BeginChild('##3', imgui.ImVec2(589 * settings.general.custom_dpi, 87 * settings.general.custom_dpi), true)
				imgui.CenterText(fa.PALETTE .. u8' �������� ���� �������:')
				imgui.Separator()
				if imgui.RadioButtonIntPtr(u8" Dark Theme ", theme, 0) then	
					theme[0] = 0
                    message_color = 0x009EFF
                    message_color_hex = '{009EFF}'
					settings.general.moonmonet_theme_enable = false
					save_settings()
					
					apply_dark_theme()
				end
				if monet_no_errors then
					if imgui.RadioButtonIntPtr(u8" MoonMonet Theme ", theme, 1) then
						theme[0] = 1
						local r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
						local argb = join_argb(0, r, g, b)
						settings.general.moonmonet_theme_enable = true
						settings.general.moonmonet_theme_color = argb
						message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
						message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
						apply_moonmonet_theme()
						save_settings()
					end
					imgui.SameLine()
					if theme[0] == 1 and imgui.ColorEdit3('## COLOR', mmcolor, imgui.ColorEditFlags.NoInputs) then
						local r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
						local argb = join_argb(0, r, g, b)
						-- settings.general.message_color = 
						-- settings.general.message_color_hex = 
						settings.general.moonmonet_theme_color = argb
						message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
						message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
						if theme[0] == 1 then
							apply_moonmonet_theme()
							save_settings()
						end
					end
				else
					if imgui.RadioButtonIntPtr(u8" MoonMonet Theme | "..fa.TRIANGLE_EXCLAMATION .. u8' ������: ���������� ����� ����������!', theme, 1) then
						theme[0] = 0
					end
				end
				imgui.EndChild()
				imgui.BeginChild("##3",imgui.ImVec2(589 * settings.general.custom_dpi, 80 * settings.general.custom_dpi),true)
				-- imgui.TextWrapped(u8('����� ��� ��� ���� ����������� �� ��������� �������? �������� �� ���� �� ����� Discord ������� ��� �� ������ BlastHack!'))
				-- imgui.TextWrapped(u8('���� �������  �� ������ �������� �������! ��������� ���� �� ����� Discord �������.'))
				imgui.CenterText(fa.MAXIMIZE .. u8' ������ ������� �������:')
				if settings.general.custom_dpi == slider_dpi[0] then
					
				else
					imgui.SameLine()
					if imgui.SmallButton(fa.CIRCLE_ARROW_RIGHT .. u8' ��������� � ���������') then
						settings.general.custom_dpi = slider_dpi[0]
						save_settings()
						sampAddChatMessage('[Justice Helper] {ffffff}������������ ������� ��� ���������� ������� ����...', message_color)
						reload_script = true
						thisScript():reload()
					end
				end
				imgui.PushItemWidth(578 * settings.general.custom_dpi)
				imgui.SliderFloat('##2223233333333', slider_dpi, 0.5, 3) 
				imgui.Separator()
				imgui.CenterText(u8('���� ������� ������� "�������" �� ������, ��������� ������ � ��������� ��������'))
				imgui.EndChild()
				imgui.BeginChild("##4",imgui.ImVec2(589 * settings.general.custom_dpi, 35 * settings.general.custom_dpi),true)
				if imgui.Button(fa.POWER_OFF .. u8" ���������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##off')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##off', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar ) then
					change_dpi()
					imgui.CenterText(u8'�� ������������� ������ ��������� (���������) ������?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.POWER_OFF .. u8' ��, ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						reload_script = true
						play_error_sound()
						sampAddChatMessage('[Justice Helper] {ffffff}������ ������������ ���� ������ �� ��������� ����� � ����!', message_color)
						if not isMonetLoader() then 
							sampAddChatMessage('[Justice Helper] {ffffff}���� ����������� ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}����� ��������� ������.', message_color)
						end
						thisScript():unload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.ROTATE_RIGHT .. u8" ������������ ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					reload_script = true
					thisScript():reload()
				end
				imgui.SameLine()
				if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8" ����� �������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##reset')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##reset', _, imgui.WindowFlags.NoResize ) then
					change_dpi()
					imgui.CenterText(u8'�� ������������� ������ �������� ��� ��������� �������?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8' ��, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						play_error_sound()
						os.remove(path_uk)
						os.remove(path_pdd)
						os.remove(path_rp_guns)
						os.remove(path_arzvehicles)
						os.remove(path_notes)
						os.remove(path_settings)
						os.remove(path_commands)
						imgui.CloseCurrentPopup()
						reload_script = true
						thisScript():reload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.TRASH_CAN .. u8" �������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##delete')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##delete', _, imgui.WindowFlags.NoResize ) then
					change_dpi()
					imgui.CenterText(u8'�� ������������� ������ ������� Justice Helper?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.TRASH_CAN .. u8' ��, � ���� �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						sampAddChatMessage('[Justice Helper] {ffffff}������ �������� ����� �� ������ ����������!', message_color)
						sampShowDialog(999999, message_color_hex .. "Justice Helper", "�� ������� ������� Justice Helper �� ������ ����������.\n���� �������� ������� � ���������� ������ �������������, � �� ������������ � ������ ��� ����������, ��\n�������� ��� ��� ������ ��������� ��� ������� ������ �� ����� Discord ������� ��� �� ������ BlastHack\n\nDiscord: https://discord.com/invite/qBPEYjfNhv\nBlastHack: https://www.blast.hk/threads/195388/\nTelegram @mtgmods\n\n���� ���, �� ������ ������ ������� � ���������� ������ � ����� ������ :)", "�������", '', 0)
						reload_script = true
						os.remove(path_helper)
						os.remove(path_uk)
						os.remove(path_pdd)
						os.remove(path_rp_guns)
						os.remove(path_arzvehicles)
						os.remove(path_notes)
						os.remove(path_settings)
						os.remove(path_commands)
						thisScript():unload()
					end
					imgui.End()
				end
				imgui.EndChild()
				imgui.EndTabItem()
			end
		imgui.EndTabBar() end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return DeportamentWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.WALKIE_TALKIE .. u8" ����� ������������", DeportamentWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 160 * settings.general.custom_dpi), true)
		imgui.Columns(3)
		imgui.CenterColumnText(u8('��� ���:'))
		imgui.PushItemWidth(215 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_tag1', input_dep_tag1, 256) then
			settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� ���##1')) then
			imgui.OpenPopup(fa.TAG .. u8' ���� �����������##1')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8' ���� �����������##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			change_dpi()
			if imgui.BeginTabBar('TabTags') then
				if imgui.BeginTabItem(fa.BARS..u8' ����������� ���� (ru) ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' ����������� ���� (en) ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_en) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' ���� ��������� ���� ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_custom) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ���', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TAG .. u8' ���������� ������ ����##1')	
					end
					if imgui.BeginPopupModal(fa.TAG .. u8' ���������� ������ ����##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						
						imgui.PushItemWidth(215 * settings.general.custom_dpi)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
			imgui.EndTabBar() 
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('������� �����:'))
		imgui.PushItemWidth(140 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_fm', input_dep_fm, 256) then
			settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� �������##1')) then
			imgui.OpenPopup(fa.WALKIE_TALKIE .. u8' ������� ��� ������������� ����� /d')
		end
		if imgui.BeginPopupModal(fa.WALKIE_TALKIE .. u8' ������� ��� ������������� ����� /d', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			imgui.SetWindowSizeVec2(imgui.ImVec2(400 * settings.general.custom_dpi, 95 * settings.general.custom_dpi))
			change_dpi()
			for i, tag in ipairs(settings.deportament.dep_fms) do
				imgui.SameLine()
				if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
					input_dep_fm = imgui.new.char[256](u8(tag))
					settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
					save_settings()
					imgui.CloseCurrentPopup()
				end
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				imgui.OpenPopup(fa.TAG .. u8' ���������� ����� �������##2')	
			end
			if imgui.BeginPopupModal(fa.TAG .. u8' ���������� ����� �������##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
				
				imgui.PushItemWidth(215 * settings.general.custom_dpi)
				imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
				imgui.Separator()
				if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					imgui.CloseCurrentPopup()
				end
				imgui.SameLine()
				if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					table.insert(settings.deportament.dep_fms, u8:decode(ffi.string(input_dep_new_tag)))
					save_settings()
					imgui.CloseCurrentPopup()
				end
				imgui.End()
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('���, � ���� �� �����������:'))
		imgui.PushItemWidth(195 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_tag2', input_dep_tag2, 256) then
			settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� ���##2')) then
			imgui.OpenPopup(fa.TAG .. u8' ���� �����������##2')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8' ���� �����������##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			change_dpi()
			if imgui.BeginTabBar('TabTags') then
				if imgui.BeginTabItem(fa.BARS..u8' ����������� ���� (ru) ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' ����������� ���� (en) ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_en) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' ���� ��������� ���� ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_custom) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ���', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TAG .. u8' ���������� ������ ����##2')	
					end
					if imgui.BeginPopupModal(fa.TAG .. u8' ���������� ������ ����##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						
						imgui.PushItemWidth(215 * settings.general.custom_dpi)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
			imgui.EndTabBar() 
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 235 * settings.general.custom_dpi)
		imgui.Columns(1)
		imgui.Separator()
		imgui.CenterText(u8('�����:'))
		imgui.PushItemWidth(490 * settings.general.custom_dpi)
		imgui.InputText(u8'##dep_input_text', input_dep_text, 256)
		imgui.SameLine()
		if imgui.Button(u8' ��������� ') then
			sampSendChat('/d ' .. u8:decode(ffi.string(input_dep_tag1)) .. ' ' .. u8:decode(ffi.string(input_dep_fm)) .. ' ' ..  u8:decode(ffi.string(input_dep_tag2)) .. ': '  .. u8:decode(ffi.string(input_dep_text)))
		end
		imgui.Separator()
		imgui.CenterText(u8'������������: /d ' .. u8(u8:decode(ffi.string(input_dep_tag1))) .. ' ' .. u8(u8:decode(ffi.string(input_dep_fm))) .. ' ' ..  u8(u8:decode(ffi.string(input_dep_tag2))) .. ': '  .. u8(u8:decode(ffi.string(input_dep_text))) )
		imgui.EndChild()
		imgui.End()
    end
)

imgui.OnFrame(
    function() return BinderWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.PEN_TO_SQUARE .. u8' �������������� ������� /' .. binder_data.change_cmd, BinderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  )
		change_dpi()
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
			imgui.CenterText(fa.FILE_LINES .. u8' �������� �������:')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##input_description", input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8' ������� ��� ������������� � ���� (��� /):')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##input_cmd", input_cmd, 256)
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8' ��������� ������� ��������� �������:')
	    	imgui.Combo(u8'',ComboTags, ImItems, #item_list)
	 	    imgui.Separator()
	        imgui.CenterText(fa.FILE_WORD .. u8' ��������� ���� �������:')
			imgui.InputTextMultiline("##text_multiple", input_text, 8192, imgui.ImVec2(579 * settings.general.custom_dpi, 173 * settings.general.custom_dpi))
		imgui.EndChild() end
		if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			BinderWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8' ��������',imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8' �������� (� ��������) ')
		end
		if imgui.BeginPopupModal(fa.CLOCK .. u8' �������� (� ��������) ', _, imgui.WindowFlags.NoResize ) then
			imgui.PushItemWidth(200 * settings.general.custom_dpi)
			imgui.SliderFloat(u8'##waiting', waiting_slider, 0.3, 10)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				waiting_slider = imgui.new.float(tonumber(binder_data.change_waiting))	
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8' ����', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8' ���� ��� ������������� � �������')
		end
		if imgui.BeginPopupModal(fa.TAGS .. u8' ���� ��� ������������� � �������', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize ) then
			imgui.Text(u8(binder_tags_text))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()


		if ComboTags[0] == 0 then
			if imgui.Button(fa.KEYBOARD .. u8' ���� (��� ��)', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
				if isMonetLoader() then
					sampAddChatMessage('[Justice Helper] {ffffff}������ ������� ������� ������ �� ��!', message_color)
				else
					if hotkey_no_errors then
						if settings.general.use_binds then 
							imgui.OpenPopup(fa.KEYBOARD .. u8' ���� ��� ������� /' .. binder_data.change_cmd)
						else
							sampAddChatMessage('[Justice Helper] {ffffff}������� �������� ��������������� ������� � ������� � ��������� - ���. ������', message_color)
						end
					else
						sampAddChatMessage('[Justice Helper] {ffffff}������ ������� ���������, ������� ���������� ����� ���������� mimgui_hotkeys!', message_color)
					end
				end
			end
		elseif ComboTags[0] == 2 then
			local temp = (binder_data.create_command_9_10) and '(/jlm)' or '(/jm)'
			if binder_data.change_in_fastmenu then
				if imgui.Button(fa.SQUARE_CHECK .. u8' FastMenu ' .. temp, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
					binder_data.change_in_fastmenu = false
				end
			else
				if imgui.Button(fa.SQUARE .. u8' FastMenu ' .. temp, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
					binder_data.change_in_fastmenu = true
				end
			end
		else
			if imgui.Button(fa.KEYBOARD .. u8' ���� (��� ��)', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
				sampAddChatMessage('[Justice Helper] {ffffff}������ ������� ������� ������ ���� ������� "��� ����������"', message_color)
			end
		end

		if imgui.BeginPopupModal(fa.KEYBOARD .. u8' ���� ��� ������� /' .. binder_data.change_cmd, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			local hotkeyObject = hotkeys[binder_data.change_cmd .. "HotKey"]
			if hotkeyObject then
				imgui.CenterText(u8('������� ��������� �����:'))
				local calc
				if binder_data.change_bind == '{}' or binder_data.change_bind == '[]' then
					calc = imgui.CalcTextSize('< click and select keys >')
				else
					calc = imgui.CalcTextSize(getNameKeysFrom(binder_data.change_bind))
				end
				local width = imgui.GetWindowWidth()
				imgui.SetCursorPosX(width / 2 - calc.x / 2)
				if hotkeyObject:ShowHotKey() then
					binder_data.change_bind = encodeJson(hotkeyObject:GetHotKey())
					sampAddChatMessage('[Justice Helper] {ffffff}������ ������ ��� ������� ' .. message_color_hex .. '/' .. binder_data.change_cmd .. ' {ffffff}�� ������� '  .. message_color_hex .. getNameKeysFrom(binder_data.change_bind), message_color)
				end
			else
				local hotkeyName = binder_data.change_cmd.. "HotKey"
				hotkeys[hotkeyName] = hotkey.RegisterHotKey(hotkeyName, false, decodeJson(binder_data.change_bind), function()
					if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
					
					else
						sampProcessChatInput('/' .. binder_data.change_cmd)
					end
				end)
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(300 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end

		imgui.SameLine()

		if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then	
			if ffi.string(input_cmd):find('%W') or ffi.string(input_cmd) == '' or ffi.string(input_description) == '' or ffi.string(input_text) == '' then
				imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' ������ ���������� �������!')
			else
				local new_arg = ''
				if ComboTags[0] == 0 then
					new_arg = ''
				elseif ComboTags[0] == 1 then
					new_arg = '{arg}'
				elseif ComboTags[0] == 2 then
					new_arg = '{arg_id}'
				elseif ComboTags[0] == 3 then
					new_arg = '{arg_id} {arg2}'
                elseif ComboTags[0] == 4 then
					new_arg = '{arg_id} {arg2} {arg3}'
				end
				local new_waiting = waiting_slider[0]
				local new_description = u8:decode(ffi.string(input_description))
				local new_command = u8:decode(ffi.string(input_cmd))
				local new_text = u8:decode(ffi.string(input_text)):gsub('\n', '&')
				local temp_array = (binder_data.create_command_9_10) and commands.commands_manage or commands.commands
				
				for _, command in ipairs(temp_array) do
					if command.cmd == binder_data.change_cmd and command.arg == binder_data.change_arg and command.text:gsub('&', '\n') == binder_data.change_text then
						command.cmd = new_command
						command.arg = new_arg
						command.description = new_description
						command.text = new_text
						command.bind = binder_data.change_bind
						command.waiting = new_waiting
						command.in_fastmenu = binder_data.change_in_fastmenu
						command.enable = true
						save_commands()
						if command.arg == '' then
							sampAddChatMessage('[Justice Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg}' then
							sampAddChatMessage('[Justice Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [��������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id}' then
							sampAddChatMessage('[Justice Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id} {arg2}' then
							sampAddChatMessage('[Justice Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] [��������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3}' then
							sampAddChatMessage('[Justice Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] [��������] [��������] {ffffff}������� ���������!', message_color)
						end
						sampUnregisterChatCommand(binder_data.change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						break
					end
				end
				BinderWindow[0] = false
			end
		end
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' ������ ���������� �������!', _, imgui.WindowFlags.AlwaysAutoResize ) then
			if ffi.string(input_cmd):find('%W') then
				imgui.BulletText(u8" � ������� ����� ������������ ������ ����. ����� �/��� �����!")
			elseif ffi.string(input_cmd) == '' then
				imgui.BulletText(u8" ������� �� ����� ���� ������!")
			end
			if ffi.string(input_description) == '' then
				imgui.BulletText(u8" �������� ������� �� ����� ���� ������!")
			end
			if ffi.string(input_text) == '' then
				imgui.BulletText(u8" ���� ������� �� ����� ���� ������!")
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end	
		imgui.End()
    end
)

imgui.OnFrame(
    function() return MembersWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if tonumber(#members) >= 16 then
			sizeYY = 413
		else
			sizeYY = 24.5 * ( tonumber(#members) + 1 )
		end
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, sizeYY * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		--imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. " " ..  u8(members_fraction) .. " - " .. #members .. u8' ����������� ������', MembersWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
		for i, v in ipairs(members) do
			imgui.Columns(3)
			if v.working then
				imgui_RGBA = imgui.ImVec4(1, 1, 1, 1) -- white
			else
				imgui_RGBA = imgui.ImVec4(1, 0.231, 0.231, 1) -- red
			end
			if tonumber(v.afk) > 0 and tonumber(v.afk) < 60 then
				imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. '] [AFK ' .. v.afk .. 's]')
			elseif tonumber(v.afk) >= 60 then
				imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. '] [AFK ' .. math.floor( tonumber(v.afk) / 60 ) .. 'm]')
			else
				imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
			end
			if imgui.IsItemClicked() and tonumber(settings.player_info.fraction_rank_number) >= 9 then 
				show_leader_fast_menu(v.id)
				MembersWindow[0] = false
			end
			imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.rank) .. ' (' .. u8(v.rank_number) .. ')')
			imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.warns .. '/3'))
			imgui.SetColumnWidth(-1, 75 * settings.general.custom_dpi)
			imgui.Columns(1)
			imgui.Separator()
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return WantedWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.wanteds_menu.x, settings.windows_pos.wanteds_menu.y), imgui.Cond.FirstUseEver)
		-- if tonumber(#wanted) >= 16 then
		-- 	sizeYY = 413 + 25 * settings.general.custom_dpi
		-- elseif tonumber(#wanted) > 0 then
		-- 	sizeYY = (24.5 * ( tonumber(#wanted) + 2 )) + (25 * settings.general.custom_dpi)
		-- elseif tonumber(#wanted) == 0 then
		-- 	sizeYY = 30 * settings.general.custom_dpi
		-- 	sampAddChatMessage('[Justice Helper] {ffffff}������ �� ������� ���� ������� � ��������!', message_color)
		-- 	WantedWindow[0] = false
		-- end
		-- imgui.SetNextWindowSize(imgui.ImVec2(350 * settings.general.custom_dpi, sizeYY * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.STAR .. u8" ������ ������������ (����� " .. #wanted .. u8')', WantedWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end

		if imgui.Button(u8'�������� ������ ������������', imgui.ImVec2(340 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			WantedWindow[0] = false
			sampAddChatMessage('[Justice Helper] {ffffff}�� ������ �������� ����-���������� /wanteds � ���������� ����������!', message_color)
			sampProcessChatInput('/wanteds')
		end
		imgui.Separator()

		imgui.Columns(3)
		imgui.CenterColumnText(u8("�������"))
		imgui.SetColumnWidth(-1, 200 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8("������"))
		imgui.SetColumnWidth(-1, 65 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8("����������"))
		imgui.SetColumnWidth(-1, 80 * settings.general.custom_dpi)
		imgui.Columns(1)
		for i, v in ipairs(wanted) do
			imgui.Separator()
			imgui.Columns(3)
			local rgbNormalized = argbToRgbNormalized(sampGetPlayerColor(v.id))  -- ����������� ARGB � RGB � ��������� �� 0.00 �� 1.00
			local imgui_RGBA = imgui.ImVec4(rgbNormalized[1], rgbNormalized[2], rgbNormalized[3], 1)
			imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
			if imgui.IsItemClicked() and not v.dist:find('� ���������') then
				sampSendChat('/pursuit ' .. v.id)
			end
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.lvl) .. ' ' .. fa.STAR)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.dist))
			imgui.NextColumn()
			imgui.Columns(1)
			
		end
		local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.wanteds_menu.x or posY ~= settings.windows_pos.wanteds_menu.y then
			settings.windows_pos.wanteds_menu = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return NoteWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.FILE_PEN .. ' '.. show_note_name, NoteWindow, imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.Text(show_note_text:gsub('&','\n'))
		-- imgui.Separator()
		-- if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
		-- 	NoteWindow[0] = false
		-- end
		
		imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		--imgui.SetNextWindowSize(imgui.ImVec2(290 * settings.general.custom_dpi, 415 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.USER .. ' '..sampGetPlayerNickname(player_id)..' ['..player_id.. ']##FastMenu', FastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		local check = false
		for _, command in ipairs(commands.commands) do
			if command.enable and command.arg == '{arg_id}' and command.in_fastmenu then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					FastMenu[0] = false
				end
				check = true
			end
		end
		if not check then
			sampAddChatMessage('[Justice Helper] {ffffff}���� ������ ���������� �� ������ � FastMenu!', message_color)
			FastMenu[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return LeaderFastMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.USER..' '..sampGetPlayerNickname(player_id)..' ['..player_id..']##LeaderFastMenu', LeaderFastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize  )
		change_dpi()
		local check = false
		for _, command in ipairs(commands.commands_manage) do
			if command.enable and command.arg == '{arg_id}' and command.in_fastmenu then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					LeaderFastMenu[0] = false
				end
			end
		end
		if not isMonetLoader() then
			if imgui.Button(u8"������ �������",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/vig '..player_id..' ')
				LeaderFastMenu[0] = false
			end
			if imgui.Button(u8"������� �� �����������",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/unv '..player_id..' ')
				LeaderFastMenu[0] = false
			end
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return GiveRankMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD.." Justice Helper##rank", GiveRankMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.CenterText(u8'�������� ���� ��� '.. sampGetPlayerNickname(player_id) .. ':')
		imgui.PushItemWidth(250 * settings.general.custom_dpi)
		imgui.SliderInt('', giverank, 1, 9)
		imgui.Separator()
		local text
		if isMonetLoader() then
			text = " ������ ����"
		else
			text = " ������ ���� [Enter]"
		end
		if imgui.Button(fa.USER_NURSE .. u8(text) , imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			give_rank()
			GiveRankMenu[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return CommandStopWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD .. " Justice Helper##CommandStopWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if isMonetLoader() and isActiveCommand then
			if imgui.Button(fa.CIRCLE_STOP..u8' ���������� ��������� ') then
				command_stop = true 
				CommandStopWindow[0] = false
			end
		else
			CommandStopWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return CommandPauseWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD.." Justice Helper##CommandPauseWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if command_pause then
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' ���������� ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				command_pause = false
				CommandPauseWindow[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' ������ STOP ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				command_stop = true 
				command_pause = false
				CommandPauseWindow[0] = false
			end
		else
			CommandPauseWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenuPlayers[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD..u8" �������� ������##fast_menu_players", FastMenuPlayers, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize  )
		change_dpi()
		if tonumber(#get_players()) == 0 then
			show_fast_menu(get_players()[1])
			FastMenuPlayers[0] = false
		elseif tonumber(#get_players()) >= 1 then
			for _, playerId in ipairs(get_players()) do
				local id = tonumber(playerId)
				if imgui.Button(sampGetPlayerNickname(id), imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if tonumber(#get_players()) ~= 0 then show_fast_menu(id) end
					FastMenuPlayers[0] = false
				end
			end
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenuButton[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.mobile_fastmenu_button.x, settings.windows_pos.mobile_fastmenu_button.y), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .." Justice Helper##fast_menu_button", FastMenuButton, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBackground  )
		change_dpi()
		if imgui.Button(fa.IMAGE_PORTRAIT..u8' �������������� ') then
			if tonumber(#get_players()) == 1 then
				show_fast_menu(get_players()[1])
				FastMenuButton[0] = false
			elseif tonumber(#get_players()) > 1 then
				FastMenuPlayers[0] = true
				FastMenuButton[0] = false
			end
		end
		local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.mobile_fastmenu_button.x or posY ~= settings.windows_pos.mobile_fastmenu_button.y then
			settings.windows_pos.mobile_fastmenu_button = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return MegafonWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.megafon.x, settings.windows_pos.megafon.y), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. " Justice Helper##fast_meg_button", MegafonWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)
		change_dpi()
		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
		if imgui.Button(fa.BULLHORN .. u8' 10-55 ',  imgui.ImVec2(75 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			sampProcessChatInput('/55')
		end
		imgui.SameLine()
		if imgui.Button(fa.BULLHORN .. u8' 10-66 ',  imgui.ImVec2(75 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			sampProcessChatInput('/66')
		end
		local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.megafon.x or posY ~= settings.windows_pos.megafon.y then
			settings.windows_pos.megafon = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
    end
)

if not settings.windows_pos.taser then
	settings.windows_pos.taser = default_settings.windows_pos.taser
end

imgui.OnFrame(
    function() return TaserWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.taser.x, settings.windows_pos.taser.y), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. " Justice Helper##TaserWindow", TaserWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)
		change_dpi()
		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
		if imgui.Button(fa.GUN .. u8' Taser ',  imgui.ImVec2(75 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			sampSendChat('/taser')
		end
		local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.taser.x or posY ~= settings.windows_pos.taser.y then
			settings.windows_pos.taser = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
    end
)

if not settings.windows_pos.info_menu then
	settings.windows_pos.info_menu = default_settings.windows_pos.info_menu
end

imgui.OnFrame(
    function() return InformationWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.info_menu.x, settings.windows_pos.info_menu.y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(225 * settings.general.custom_dpi, 113 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. u8" Justice Helper##info_menu", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar  )
		if not isMonetLoader() and not sampIsChatInputActive() then player.HideCursor = true else player.HideCursor = false end
		change_dpi()
		imgui.Text(fa.CITY .. u8(' �����: ') .. u8(tagReplacements.get_city()))
		imgui.Text(fa.MAP_LOCATION_DOT .. u8(' �����: ') .. u8(tagReplacements.get_area()))
		imgui.Text(fa.LOCATION_CROSSHAIRS .. u8(' �������: ') .. u8(tagReplacements.get_square()))
		imgui.Separator()
		imgui.Text(fa.CLOCK .. u8(' ������� �����: ') .. u8(tagReplacements.get_time()))
        local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.info_menu.x or posY ~= settings.windows_pos.info_menu.y then
			settings.windows_pos.info_menu = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return PatroolMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.patrool_menu.x, settings.windows_pos.patrool_menu.y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(225 * settings.general.custom_dpi, 113 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. u8" Justice Helper##patrool_info_menu", PatroolMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
		if patrool_active then
			imgui.Text(fa.CLOCK .. u8(' ����� ��������������: ') .. u8(tagReplacements.get_patrool_time()))
			imgui.Separator()
			imgui.Text(fa.CIRCLE_INFO .. u8(' ���� ���������: ') .. u8(tagReplacements.get_patrool_code()))
			imgui.SameLine()
			if imgui.SmallButton(fa.GEAR) then
				imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Justice Helper##patrool_select_code'))
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_INFO .. u8(' ������'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function ()
					sampSendChat('/r ' .. tagReplacements.my_doklad_nick() .. ' �� CONTROL.')
					wait(1500)
					sampSendChat('/r ��������� �������, �������� � ������ ' .. tagReplacements.get_area() .. " (" .. tagReplacements.get_square() .. ').')
					wait(1500)
					if tagReplacements.get_car_units() ~= '����' then
						sampSendChat('/r ���������� ��� ' .. format_patrool_time(patrool_time) .. ' � ������� ����� ' .. tagReplacements.get_car_units() .. ', ��������� ' .. u8(tagReplacements.get_patrool_code()) .. '.')
					else
						sampSendChat('/r ���������� ��� ' .. format_patrool_time(patrool_time) .. ', ��������� ' .. u8(tagReplacements.get_patrool_code()) .. '.')
					end
				end)
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_STOP .. u8(' ���������'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function ()
					patrool_active = false
					sampSendChat('/r ' .. tagReplacements.my_doklad_nick() .. ' �� CONTROL.')
					wait(1500)
					sampSendChat('/r �������� �������, ���������� ���������� ' .. tagReplacements.get_patrool_mark() .. ', ��������� ' .. tagReplacements.get_patrool_code())
					wait(1500)
					sampSendChat('/r ������������ ' .. format_patrool_time(patrool_time), -1)
					patrool_time = 0
					patrool_start_time = 0
					patrool_current_time = 0
					patrool_code = 'CODE4'
					ComboPatroolCode[0] = 5
					PatroolMenu[0] = false
					wait(1200)
					sampSendChat('/delvdesc')
				end)
			end
		else
			player.HideCursor = false	
			if imgui.Button(fa.CIRCLE_PLAY .. u8(' ������ �������'), imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				if isCharInAnyCar(PLAYER_PED) then
					imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Justice Helper##start_patrool'))
				else
					PatroolMenu[0] = false
					sampAddChatMessage('[Justice Helper] {ffffff}������ ������ �������, �� ������ ���� �� ���� ����������!', message_color)
				end
			end
		end
		if imgui.BeginPopupModal(fa.BUILDING_SHIELD .. u8(' Justice Helper##start_patrool'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
			change_dpi()
			player.HideCursor = false 
			imgui.CenterText(u8('��������� ������ ����� ������� �������:'))
			imgui.Separator()
			imgui.Text(fa.CIRCLE_INFO .. u8(' ���� ����������: '))
			imgui.SameLine()
			imgui.PushItemWidth(150 * settings.general.custom_dpi)
			if imgui.Combo('##patrool_mark', ComboPatroolMark, ImItemsPatroolMark, #combo_patrool_mark_list) then
				patrool_mark = combo_patrool_mark_list[ComboPatroolMark[0] + 1] 
			end
			imgui.Separator()
			imgui.Text(fa.CIRCLE_INFO .. u8(' ���� ���������: '))
			imgui.SameLine()
			imgui.PushItemWidth(150 * settings.general.custom_dpi)
			if imgui.Combo('##patrool_code', ComboPatroolCode, ImItemsPatroolCode, #combo_patrool_code_list) then
				patrool_code = combo_patrool_code_list[ComboPatroolCode[0] + 1]
			end
			imgui.Separator()
			imgui.Text(fa.CIRCLE_INFO .. u8(' ���������: ') .. u8(tagReplacements.get_car_units()))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(fa.PLAY .. u8' ������ �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				patrool_time = 0
				patrool_start_time = os.time()
				patrool_active = true
				lua_thread.create(function ()
					sampSendChat('/r ' .. tagReplacements.my_doklad_nick() .. ' �� CONTROL.')
					wait(1500)
					sampSendChat('/r ������� �������, �������� � ������ ' .. tagReplacements.get_area() .. " (" .. tagReplacements.get_square() .. ').')
					wait(1500)
					if tagReplacements.get_car_units() ~= '����' then
						sampSendChat('/r ������� ���������� ' .. tagReplacements.get_patrool_mark() .. ', �������� � ������� ����� ' .. tagReplacements.get_car_units() .. ', ��������� ' .. tagReplacements.get_patrool_code() .. '.')
					else
						sampSendChat('/r ������� ���������� ' .. tagReplacements.get_patrool_mark() .. ', ��������� ' .. tagReplacements.get_patrool_code() .. '.')
					end
					wait(1500)
					sampSendChat('/vdesc ' .. tagReplacements.get_patrool_mark())
				end)
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		if imgui.BeginPopup(fa.BUILDING_SHIELD .. u8(' Justice Helper##patrool_select_code'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
			change_dpi()
			player.HideCursor = false 
			imgui.PushItemWidth(150 * settings.general.custom_dpi)
			if imgui.Combo('##patrool_code', ComboPatroolCode, ImItemsPatroolCode, #combo_patrool_code_list) then
				patrool_code = combo_patrool_code_list[ComboPatroolCode[0] + 1]
				imgui.CloseCurrentPopup()
			end
			-- imgui.Separator()
			-- if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			-- 	imgui.CloseCurrentPopup()
			-- end
			imgui.EndPopup()
		end
		local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.patrool_menu.x or posY ~= settings.windows_pos.patrool_menu.y then
			settings.windows_pos.patrool_menu = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return UpdateWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.CIRCLE_INFO .. u8" ����������##need_update_helper", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		if not isMonetLoader() then change_dpi() end
		imgui.CenterText(u8'� ��� ������ ����������� ������ ������� ' .. u8(tostring(thisScript().version)) .. ".")
		imgui.CenterText(u8'� ���� ������ ������� ������ ������� - ' .. u8(updateVer) .. ".")
		imgui.CenterText(u8'������������� ����������, ���� ����� ���� ���������� ����������!')
		imgui.Separator()
		imgui.CenterText(u8('��� ������ � ������ ') .. u8(updateVer) .. ':')
		imgui.Text(u8(updateInfoText))
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' �� ��������� ',  imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			UpdateWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.DOWNLOAD ..u8' ��������� ����� ������',  imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			download_helper = true
			downloadFileFromUrlToPath(updateUrl, path_helper)
			UpdateWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return SobesMenu[0] end,
    function(player)
		if player_id ~= nil and isParamSampID(player_id) then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.PERSON_CIRCLE_CHECK..u8' ���������� ������������� ������ ' .. sampGetPlayerNickname(player_id), SobesMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			if imgui.BeginChild('sobes1', imgui.ImVec2(240 * settings.general.custom_dpi, 182 * settings.general.custom_dpi), true) then
			imgui.CenterColumnText(fa.BOOKMARK .. u8" ��������")
			imgui.Separator()
			if imgui.Button(fa.PLAY .. u8" ������ �������������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function()
					sampSendChat("������������, � " .. settings.player_info.name_surname .. " - " .. settings.player_info.fraction_rank .. ' ' .. settings.player_info.fraction_tag)
					wait(2000)
					sampSendChat("�� ������ � ��� �� �������������?")
				end)
			end
			if imgui.Button(fa.PASSPORT .. u8" ��������� ���������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function()
					sampSendChat("������, ������������ ��� ��� ���� ��������� ��� ��������.")
					wait(2000)
					sampSendChat("��� ����� ��� �������, ���.����� � ��������.")
					wait(2000)
					sampSendChat("/n " .. sampGetPlayerNickname(player_id) .. ", ����������� /showpass [ID] , /showmc [ID] , /showlic [ID]")
					wait(2000)
					sampSendChat("/n ����������� � RP �����������!")
				end)
			end
			if imgui.Button(fa.USER .. u8" ���������� � ����", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				sampSendChat("������� ���������� � ����.")
			end
			
			if imgui.Button(fa.CHECK .. u8" ������������� ��������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				sampSendChat("/todo ����������! �� ������� ������ �������������!*��������")
			end
			if imgui.Button(fa.USER_PLUS .. u8" ���������� � �����������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				find_and_use_command('/invite {arg_id}', player_id)
				SobesMenu[0] = false
			end
			imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes2', imgui.ImVec2(240 * settings.general.custom_dpi, 182 * settings.general.custom_dpi), true) then
				imgui.CenterColumnText(fa.BOOKMARK..u8" �������������")
				imgui.Separator()
				if imgui.Button(fa.GLOBE .. u8" ������� ����.����� Discord", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� �� � ��� ����. ����� Discord?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ������� ����� ������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� �� � ��� ���� ������ � ����� �����?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ������ ������ ��?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� ������ �� ������� ������ ���?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ��� ����� ������������?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� ��� �� ������ ������ \"������������\"?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ��� ����� ��?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� ��� �� �������, ��� ����� \"��\"?")
				end
			imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes3', imgui.ImVec2(150 * settings.general.custom_dpi, -1), true) then
				imgui.CenterColumnText(fa.CIRCLE_XMARK .. u8" ������")
				imgui.Separator()
				if imgui.Selectable(u8"���� ��������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� ��������.")
						wait(2000)
						sampSendChat("�������� ������� � ���������� ����� �� 1 ����� �����.")
					end)
				end
				if imgui.Selectable(u8"���� ���.�����") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� ���.�����, �������� � � ����� ��������.")
					end)
				end
				if imgui.Selectable(u8"���� �������� ������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� �������� ������ �� �����!")
                        wait(2000)
						sampSendChat("/n �������� ��� ����� �������� � ����� ���� ������ � /donate ")
					end)
				end

				if imgui.Selectable(u8"���� �����") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� �����. ��������� ���� ����� ���� ����������� � ���, ����� ��������� � ���!")
					end)
				end	
                if imgui.Selectable(u8"�����������������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ������ �����������������.")
						wait(2000)
						sampSendChat("/n ���������� ����� ������� 35 �����������������!")
					end)
				end
				if imgui.Selectable(u8"����������������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("�� ��������������, ������� ��� ���������� ���������� � ��������!")
					end)
				end
				
				if imgui.Selectable(u8"�������� ��������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� ��������, �� �� ������ ���������� � ���!")
						wait(2000)
						sampSendChat("�� ������ ���������� � ��, ���� � �������� �������� ������������")
					end)
				end
				if imgui.Selectable(u8"����.�������������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("�� �� ��������� ��� ����� ������ �� ���������������� ���������.")
					end)
				end
			end
			imgui.EndChild()
		else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ������, ID ������ ��������������!', message_color)
			SobesMenu[0] = false
		end
    end
)

imgui.OnFrame(
    function() return RPWeaponWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.GUN .. u8" RP ��������� ������##rpgun_menu", RPWeaponWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()

        -- imgui.CenterText(u8('������� RP ��������� ������: ') .. (settings.general.rp_gun and u8('��������.') or u8('���������.')))
        
        -- local buttonText = settings.general.rp_gun and u8('���������') or u8('��������')
        -- if imgui.CenterButton(buttonText) then
        --     settings.general.rp_gun = not settings.general.rp_gun
        --     save_settings()
        -- end
        imgui.PushItemWidth(580 * settings.general.custom_dpi)
        imgui.InputTextWithHint(u8'##inputsearch_weapon_name', u8('������� ���� ������ ����� ������ �� ID ��� ��������...'), input_weapon_name_search, 256) 
        imgui.Separator()
        imgui.Columns(3)
        imgui.CenterColumnText(u8"�����������������")
        imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
        imgui.NextColumn()
        imgui.CenterColumnText(u8"ID ������ � �������� ������")
        imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
        imgui.NextColumn()
        imgui.CenterColumnText(u8"������������")
        imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
        imgui.Columns(1)
        imgui.Separator()
        for index, value in ipairs(rp_guns) do

            if u8:decode(ffi.string(input_weapon_name_search)) == '' or value.name:rupper():find(u8:decode(ffi.string(input_weapon_name_search)):rupper()) or value.id == tonumber(u8:decode(ffi.string(input_weapon_name_search)))  then

                imgui.Columns(3)
                if value.enable then
                    if imgui.CenterColumnSmallButton(fa.SQUARE_CHECK .. u8' ��������##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
                        value.enable = not value.enable
                        save_rp_guns()
                    end
                else
                    if imgui.CenterColumnSmallButton(fa.SQUARE .. u8' ���������##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
                        value.enable = not value.enable
                        save_rp_guns()
                    end
                end
                imgui.NextColumn()
                imgui.CenterColumnText('[' .. value.id .. '] ' .. u8(value.name))
                imgui.SameLine()
                if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##weapon_name' .. index) then
                    imgui.StrCopy(input_weapon_name, u8(value.name))
                    imgui.OpenPopup(fa.GUN .. u8' �������� ������##weapon_name' .. index)
                end
                if imgui.BeginPopupModal(fa.GUN .. u8' �������� ������##weapon_name' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
                    imgui.PushItemWidth(400 * settings.general.custom_dpi)
                    imgui.InputText(u8'##weapon_name', input_weapon_name, 256) 
                    if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
                        for i = 1, 10, 1 do
							sampAddChatMessage('[Justice Helper] {ffffff}������ ������� �������� ������ � ������� ������ �������! �������� � MTG MODS', message_color)
						end
                        imgui.CloseCurrentPopup()
                    end
                    imgui.End()
                end
                imgui.NextColumn()
                local position = ''
                if value.rpTake == 1 then
                    position = '�����'
                elseif value.rpTake == 2 then
                    position = '������'
                elseif value.rpTake == 3 then
                    position = '����'
                elseif value.rpTake == 4 then
                    position = '������'
                end
                imgui.CenterColumnText(u8(position))
                imgui.SameLine()
                if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##weapon_position' .. index) then
					ComboTags2[0] = value.rpTake - 1
                    imgui.OpenPopup(fa.GUN .. u8' ������������ ������##weapon_name' .. index)
                end
                if imgui.BeginPopupModal(fa.GUN .. u8' ������������ ������##weapon_name' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
                    imgui.PushItemWidth(400 * settings.general.custom_dpi)
                    imgui.Combo(u8'##' .. index, ComboTags2, ImItems2, #item_list2)
                    if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
                        for i = 1, 10, 1 do
							sampAddChatMessage('[Justice Helper] {ffffff}������ ������� �������� ������ � ������� ������ �������! �������� � MTG MODS', message_color)
						end
                        imgui.CloseCurrentPopup()
                    end
                    imgui.End()
                end
                imgui.Columns(1)
                imgui.Separator()

            end

        end
        imgui.End()
    end
)

imgui.OnFrame(
    function() return SumMenuWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.STAR .. u8" ����� ������ �������##sum_menu", SumMenuWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
		if smart_uk ~= nil and isParamSampID(player_id) then
			imgui.PushItemWidth(580 * settings.general.custom_dpi)
			imgui.InputTextWithHint(u8'##input_sum', u8('����� ������ (����������) � ������ (�������)'), input_sum, 128) 
			imgui.Separator()
			local input_sum_decoded = u8:decode(ffi.string(input_sum))
			for _, chapter in ipairs(smart_uk) do
				local chapter_has_matching_item = false
				if chapter.item then
					for _, item in ipairs(chapter.item) do
						if item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
							chapter_has_matching_item = true
							break
						end
					end
				end
				if chapter_has_matching_item then
					if imgui.CollapsingHeader(u8(chapter.name)) then
						for _, item in ipairs(chapter.item) do
							if item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
								local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' ������������� ������ ����� ������� �������##' .. item.text .. item.lvl .. item.reason
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
								--imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
								if imgui.Button(u8(split_text_into_lines(item.text, 85))..'##' .. item.text .. item.lvl .. item.reason, imgui.ImVec2(imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
									imgui.OpenPopup(popup_id)
								end
								--imgui.PopStyleColor()
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
								if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
									imgui.Text(fa.USER .. u8' �����: ' .. u8(sampGetPlayerNickname(player_id)) .. '[' .. player_id .. ']' .. ' [' .. sampGetPlayerScore(player_id) .. ' lvl]')
									imgui.Text(fa.STAR .. u8' ������� �������: ' .. item.lvl)
									imgui.Text(fa.COMMENT .. u8' ������� ������ �������: ' .. u8(item.reason))
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.STAR .. u8' ��������� ������', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										SumMenuWindow[0] = false
										find_and_use_command('����� �������� � ������ %{arg2%} ������� ���� N%{arg_id%}%. �������%: %{arg3%}', player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									local text_rank = ((settings.general.fraction == '���' or settings.general.fraction == 'FBI') and ' [4+]' or ' [5+]')
									if imgui.Button(fa.STAR .. u8' ������ ������' .. text_rank, imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										SumMenuWindow[0] = false
										find_and_use_command('/su {arg_id} {arg2} {arg3}', player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
										imgui.CloseCurrentPopup()
									end
									imgui.EndPopup()
								end
							end
						end
					end
				end
			end
        else
            sampAddChatMessage('[Justice Helper] {ffffff}��������� ������ ������ ������� (���� ������ ���� ����� �������)!', message_color)
            SumMenuWindow[0] = false
        end
        imgui.End()
    end
)

imgui.OnFrame(
    function() return TsmMenuWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.TICKET .. u8" ����� ������ �������##tsm_menu", TsmMenuWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
		if smart_pdd ~= nil and isParamSampID(player_id) then
			imgui.PushItemWidth(580 * settings.general.custom_dpi)
			imgui.InputTextWithHint(u8'##input_tsm', u8('����� ������ (����������) � ������ (�������)'), input_tsm, 128) 
			imgui.Separator()
			local input_tsm_decoded = u8:decode(ffi.string(input_tsm))
			for _, chapter in ipairs(smart_pdd) do
				local chapter_has_matching_item = false
				if chapter.item then
					for _, item in ipairs(chapter.item) do
						if item.text:rupper():find(input_tsm_decoded:rupper()) or input_tsm_decoded == '' then
							chapter_has_matching_item = true
							break
						end
					end
				end
				if chapter_has_matching_item then
					if imgui.CollapsingHeader(u8(chapter.name)) then
						for _, item in ipairs(chapter.item) do
							if item.text:rupper():find(input_tsm_decoded:rupper()) or input_tsm_decoded == '' then
								local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' ������������� ������ ����� ������� ������##' .. item.text .. item.amount .. item.reason
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
								
								if imgui.Button(u8(split_text_into_lines(item.text,85))..'##' .. item.text .. item.amount .. item.reason, imgui.ImVec2( imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
									imgui.OpenPopup(popup_id)
								end 
								
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
								if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
									imgui.Text(fa.USER .. u8' �����: ' .. u8(sampGetPlayerNickname(player_id)) .. '[' .. player_id .. ']' .. ' [' .. sampGetPlayerScore(player_id) .. ' lvl]')
									imgui.Text(fa.MONEY_CHECK_DOLLAR .. u8' ����� ������: $' .. item.amount)
									imgui.Text(fa.COMMENT .. u8' ������� ������ ������: ' .. u8(item.reason))
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.TICKET .. u8' �������� �����', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										TsmMenuWindow[0] = false
										find_and_use_command('/writeticket {arg_id}', player_id .. ' ' .. item.amount .. ' ' .. item.reason)
										imgui.CloseCurrentPopup()
									end
									imgui.EndPopup()
								end
							end
						end
					end
				end
			end
        else
			sampAddChatMessage('[Justice Helper] {ffffff}��������� ������ ����� ������� (���� ������ ���� ����� �������)!', message_color)
            TsmMenuWindow[0] = false
        end
        imgui.End()
    end
)

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function imgui.CenterTextDisabled(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.TextDisabled(text)
end
function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end
function imgui.CenterColumnTextDisabled(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextDisabled(text)
end
function imgui.CenterColumnColorText(imgui_RGBA, text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.TextColored(imgui_RGBA, text)
end
function imgui.CenterButton(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
	if imgui.Button(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.Button(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnSmallButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.SmallButton(text) then
		return true
	else
		return false
	end
end
function imgui.GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth() 
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or width/count - ((space * (count-1)) / count)
end
function apply_dark_theme()
	imgui.SwitchContext()
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.12, 0.12, 0.12, 0.95)
end
function apply_moonmonet_theme()
	local generated_color = moon_monet.buildColors(settings.general.moonmonet_theme_color, 1.0, true)
	imgui.SwitchContext()
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().Colors[imgui.Col.Text] = ColorAccentsAdapter(generated_color.accent2.color_50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextDisabled] = ColorAccentsAdapter(generated_color.neutral1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.WindowBg] = ColorAccentsAdapter(generated_color.accent2.color_900):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ChildBg] = ColorAccentsAdapter(generated_color.accent2.color_800):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PopupBg] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Border] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Separator] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x60):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x70):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBg] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0x7f):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x91):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0,0,0,0)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x85):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.CheckMark] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x80):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Button] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Tab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabActive] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Header] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLines] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0x99):as_vec4()
end
function argbToHexWithoutAlpha(alpha, red, green, blue)
    return string.format("%02X%02X%02X", red, green, blue)
end
function rgba_to_argb(rgba_color)
    -- �������� ���������� �����
    local r = bit32.band(bit32.rshift(rgba_color, 24), 0xFF)
    local g = bit32.band(bit32.rshift(rgba_color, 16), 0xFF)
    local b = bit32.band(bit32.rshift(rgba_color, 8), 0xFF)
    local a = bit32.band(rgba_color, 0xFF)
    
    -- �������� ARGB ����
    local argb_color = bit32.bor(bit32.lshift(a, 24), bit32.lshift(r, 16), bit32.lshift(g, 8), b)
    
    return argb_color
end
function join_argb(a, r, g, b)
    local argb = b 
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))    
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end
function rgba_to_hex(rgba)
    local r = bit.rshift(rgba, 24) % 256
    local g = bit.rshift(rgba, 16) % 256
    local b = bit.rshift(rgba, 8) % 256
    local a = rgba % 256
    return string.format("%02X%02X%02X", r, g, b)
end
function ARGBtoRGB(color) 
	return bit.band(color, 0xFFFFFF) 
end
function ColorAccentsAdapter(color)
    local a, r, g, b = explode_argb(color)
    local ret = {a = a, r = r, g = g, b = b}
    function ret:apply_alpha(alpha)
        self.a = alpha
        return self
    end
    function ret:as_u32()
        return join_argb(self.a, self.b, self.g, self.r)
    end
    function ret:as_vec4()
        return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, self.a / 255)
    end
    function ret:as_argb()
        return join_argb(self.a, self.r, self.g, self.b)
    end
    function ret:as_rgba()
        return join_argb(self.r, self.g, self.b, self.a)
    end
    function ret:as_chat()
        return string.format("%06X", ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b)))
    end  
    return ret
end
if not isMonetLoader() then
	function onWindowMessage(msg, wparam, lparam)
		if(msg == 0x100 or msg == 0x101) then
			if (wparam == 13 and GiveRankMenu[0]) and not isPauseMenuActive() then
				consumeWindowMessage(true, false)
				if (msg == 0x101) then
					GiveRankMenu[0] = false
					give_rank()
				end
			end
		end
	end
end

function processWeaponRP(oldGun, nowGun)
    if not gunOff[oldGun] or not gunOn[nowGun] then return end
    
    if oldGun == 0 and nowGun == 0 then
        -- ������ �� ������
    elseif oldGun == 0 and not isEnableWeapon(nowGun) then
        sampAddChatMessage('[Justice Helper] {ffffff}��������� �� ��������� ��������� ��� ' .. message_color_hex ..  get_name_weapon(nowGun) .. ' [' .. nowGun .. ']{ffffff}, ��������� �', message_color)
    elseif nowGun == 0 and not isEnableWeapon(oldGun) then
        sampAddChatMessage('[Justice Helper] {ffffff}��������� �� ��������� ��������� ��� ' .. message_color_hex ..  get_name_weapon(oldGun) .. ' [' .. oldGun .. ']{ffffff}, ��������� �', message_color)
    elseif not isEnableWeapon(oldGun) and isEnableWeapon(nowGun) then
        sampAddChatMessage('[Justice Helper] {ffffff}��������� �� ��������� ��������� ��� ' .. message_color_hex ..  get_name_weapon(oldGun) .. ' [' .. oldGun .. ']{ffffff}, ��������� �', message_color)
        sampSendChat("/me " .. gunOn[nowGun] .. " " .. get_name_weapon(nowGun) .. " " .. gunPartOn[nowGun])
    elseif isEnableWeapon(oldGun) and not isEnableWeapon(nowGun) then
        sampAddChatMessage('[Justice Helper] {ffffff}��������� �� ��������� ��������� ��� ' .. message_color_hex ..  get_name_weapon(nowGun) .. ' [' .. nowGun .. ']{ffffff}, ��������� �', message_color)
        sampSendChat("/me " .. gunOff[oldGun] .. " " .. get_name_weapon(oldGun) .. " " .. gunPartOff[oldGun])
    elseif oldGun == 0 and gunOn[nowGun] then
        sampSendChat("/me " .. gunOn[nowGun] .. " " .. get_name_weapon(nowGun) .. " " .. gunPartOn[nowGun])
    elseif nowGun == 0 and gunOff[oldGun] then
        sampSendChat("/me " .. gunOff[oldGun] .. " " .. get_name_weapon(oldGun) .. " " .. gunPartOff[oldGun])
    else
        sampSendChat("/me " .. gunOff[oldGun] .. " " .. get_name_weapon(oldGun) .. " " .. gunPartOff[oldGun] .. ", ����� ���� " .. gunOn[nowGun] .. " " .. get_name_weapon(nowGun) .. " " .. gunPartOn[nowGun])
    end
end


function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 

	if tostring(settings.general.version) ~= tostring(thisScript().version) then 
		settings.general.version = thisScript().version
		save_settings()
	end

	if not isMonetLoader() then loadHotkeys() end
	welcome_message()
	initialize_commands()
	
	if settings.player_info.name_surname == '' or settings.player_info.fraction == '����������' then
		sampAddChatMessage('[Justice Helper] {ffffff}������� �������� ��� /stats ��������� ���������� ������ ��� ���!', message_color)
		check_stats = true
		sampSendChat('/stats')
	end
	if settings.general.use_info_menu then
		InformationWindow[0] = true
	end	
	if settings.general.use_taser_menu and isMonetLoader() then
		TaserWindow[0] = true
	end	
	if settings.general.mobile_meg_button and isMonetLoader() then
		MegafonWindow[0] = true
	end	
	
	if not string.rupper(settings.general.version):find('VIP') then
		check_update()
	end

	while true do
		wait(1)

		isRightMousePressed = isKeyDown(0x02)

		if patrool_active then
			patrool_time = os.difftime(os.time(), patrool_start_time)
		end	

		if isMonetLoader() then
			if settings.general.mobile_fastmenu_button then
				if tonumber(#get_players()) > 0 and not FastMenu[0] and not FastMenuPlayers[0] then
					FastMenuButton[0] = true
				else
					FastMenuButton[0] = false
				end
			end
		end 

		if nowGun ~= getCurrentCharWeapon(PLAYER_PED) and settings.general.rp_gun then
			oldGun = nowGun
			nowGun = getCurrentCharWeapon(PLAYER_PED)
			lastProcessedWeapon = nil -- ���������� ��� ����� ������
			
			-- ��������� ������ ����������� ������ ������
			if not isExistsWeapon(oldGun) then
				sampAddChatMessage('[Justice Helper] {ffffff}���������� ����� ������ � ID ' .. message_color_hex .. oldGun .. '{ffffff}, ��� ��� ��� "������" � ������������ "�����".', message_color)
				table.insert(rp_guns, {id = oldGun, name = "������", enable = true, rpTake = 1})
				init_guns()
				save_rp_guns()
			end
		end
		
		-- ������������������ ��������� �� ���
		if isRightMousePressed and settings.general.rp_gun and nowGun ~= oldGun then
			if lastProcessedWeapon ~= nowGun then
				processWeaponRP(oldGun, nowGun)
				lastProcessedWeapon = nowGun
			end
		end

		local currentMinute = os.date("%M", os.time())
		local currentSecond = os.date("%S", os.time())
		if ((currentMinute == "55" or currentMinute == "25") and currentSecond == "00") then
			if sampGetPlayerColor(tagReplacements.my_id()) == 368966908 then
				sampAddChatMessage('[Justice Helper] {ffffff}����� 5 ����� ����� PAYDAY. �������� ����� ����� �� ���������� ��������!', message_color)
				wait(1000)
			end
		end

	end
end

function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit and not reload_script then
		sampAddChatMessage('[Justice Helper] {ffffff}��������� ����������� ������, ������ ������������ ���� ������!', message_color)
		if not isMonetLoader() then 
			sampAddChatMessage('[Justice Helper] {ffffff}����������� ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}����� ������������� ������.', message_color)
		end
		setInfraredVision(false)
		setNightVision(false)
		play_error_sound()
    end
end