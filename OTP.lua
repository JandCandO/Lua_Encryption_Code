
--editables START
local standardKeyLength=40
local numberOfKeys=4
--editables END


local alphabet={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","_","1","2","3","4","5","6","7","8","9","0",".",",","?","!","(",")","/","-","=","+","'","*","%","&","^","$","#","@","<",">","~","`"}

local keyList={}

function generateKey(keyLength)
  local key={}
  for i=1,keyLength do
    key[i]=math.random(1,27)
  end
  return key
end

function generateKeyList(stdKeyLength,_numberOfKeys)
  for i=1,_numberOfKeys do
    table.insert(keyList,generateKey(stdKeyLength))
  end
end

function encode(message,key)
  text=string.gsub(message,"[ ]","_") --replace spaces with underscores for encoding
  local encodedMessage=""
  local newLayer=""
  for i=1,#text do
    for j=1,#alphabet do
      if string.sub(text,i,i)==alphabet[j]then
        newLayer=j+key[i]
        if newLayer>#alphabet then newLayer=newLayer-#alphabet end
        encodedMessage=encodedMessage..alphabet[newLayer]
      end
    end
  end
  return encodedMessage
end

function decode(crypt,key)
  local decodedMessage=""
  local newLayer=""
  for i=1,#crypt do
    for j=1,#alphabet do
      if string.sub(crypt,i,i)==alphabet[j]then
        newLayer=j-key[i]
        if newLayer<1 then newLayer=newLayer+#alphabet end
        decodedMessage=decodedMessage..alphabet[newLayer]
      end
    end
  end
  return string.gsub(decodedMessage,"[_]"," ")
end

function useUserKey(userKey)
  local key={}
  for m in string.gmatch(userKey, "(%d+)") do
    table.insert(key,m)
  end
  return key
end

local encryptions={}

generateKeyList(standardKeyLength,numberOfKeys)
print(numberOfKeys.." keys were generated, all "..standardKeyLength.." characters in length.\n")
for i=1,numberOfKeys do
  print("Enter a message to be encoded:")
  local message=io.read()
  print()
  encoded=encode(message,keyList[i])
  print('"'..message..'" was encrypted to "'..encoded..'" using key '..i..".\n")
  table.insert(encryptions,encoded)
end
print()
print(string.rep("-",51))
print()
for i=1,numberOfKeys do
  local decoded=decode(encryptions[i],keyList[i])
  print('"'..encryptions[i]..'" was decrypted to "'..decoded..'" using key '..i..".\n")
end
