-- Editable Variables Start --
local standardKeyLength = 128
local numberOfKeys = 2
math.randomseed(os.time())
-- Editable Variables End --

local function chararray(str)
	local tb = {}
	for i = 1, str:len(), 1 do
		table.insert(tb, str:sub(i, i))
	end;
	return tb
end;
local alphabet = chararray("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890.,?!()/-=+*%&^$#@<>~`;:")

local keyList = {}

function generateKey(keyLength)
	local Key = {}
	for i = 1, keyLength do
		Key[i] = math.random(1, #alphabet)
	end
	return Key
end

function generateKeyList(stdKeyLength, _numberOfKeys)
	for i = 1, _numberOfKeys do
		table.insert(keyList, generateKey(stdKeyLength))
	end
end

function Encrypt(Message, Key)
	text = string.gsub(Message, "[ ]", "_")
  --Replace spaces with underscores for encoding
	local encodedMessage = ""
	local newLayer = ""
	for i = 1, #text do
		for j = 1, #alphabet do
			if string.sub(text, i, i) == alphabet[j] then
				newLayer = j + Key[i]
				if newLayer > #alphabet then
					newLayer = newLayer - #alphabet
				end
				encodedMessage = encodedMessage .. alphabet[newLayer]
			end
		end
	end
	return encodedMessage
end

function Decrypt(Message, Key)
	local decodedMessage = ""
	local newLayer = ""
	for i = 1, #Message do
		for j = 1, #alphabet do
			if string.sub(Message, i, i) == alphabet[j] then
				newLayer = j - Key[i]
				if newLayer < 1 then
					newLayer = newLayer + #alphabet
				end
				decodedMessage = decodedMessage .. alphabet[newLayer]
			end
		end
	end
	return string.gsub(decodedMessage, "[_]", " ")
end

function useUserKey(userKey)
	local Key = {}
	for m in string.gmatch(userKey, "(%d+)") do
		table.insert(Key, m)
	end
	return Key
end

local encryptions = {}

print(string.rep("-", 51))
print()
generateKeyList(standardKeyLength, numberOfKeys)
if numberOfKeys > 1 then
print(numberOfKeys .. " keys were generated, all " .. standardKeyLength .. " characters in length.\n")
for i = 1, #keyList do
	print("Key " .. i .. ":")
	for j = 1, #keyList[i] do
		io.write(":" .. keyList[i][j])
	end
	print("\n")
end
else
  print(numberOfKeys .. " key was generated, being " .. standardKeyLength .. " characters in length.\n")
for i = 1, #keyList do
	print("Key " .. i .. ":")
	for j = 1, #keyList[i] do
		io.write(":" .. keyList[i][j])
	end
	print("\n")
end
end
print()
print(string.rep("-", 51))
print()
for i = 1, numberOfKeys do
	print("Enter a Message to be encoded:")
	io.write(">")
	local Message = io.read()
	print()
	encoded = Encrypt(Message, keyList[i])
	print('"' .. Message .. '"\nwas encrypted to\n"' .. encoded .. '"\nusing Key ' .. i .. ".\n")
	table.insert(encryptions, encoded)
end
print()
print(string.rep("-", 51))
print()
for i = 1, numberOfKeys do
	local decoded = Decrypt(encryptions[i], keyList[i])
	print('"' .. encryptions[i] .. '"\nwas decrypted to\n"' .. decoded .. '"\nusing Key ' .. i .. ".\n")
end
