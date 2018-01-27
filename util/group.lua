local Group = Class {}

function Group:init(updateObjects, shouldSort, sortFunction)

  self.updateObjects = updateObjects or false
  self.shouldSort = shouldSort or false
  self.sortFunction = sortFunction
  self.objectList = {}

end

function Group:update(dt)

  for i,object in ipairs(self.objectList) do
    if self.updateObjects and object.update then object:update(dt) end
    if object.dead then table.remove(self.objectList, i) end
  end

  if self.shouldSort then
    self:sort()
  end

end

function Group:draw()

  for i,object in ipairs(self.objectList) do
    object:draw()
  end

end

function Group:sort()

  table.sort(self.objectList, self.sortFunction)

end

function Group:add(object)

  if not self:isObjectInGroup(object) then
    table.insert(self.objectList, object)
    return true
  end
  return false

end

function Group:isObjectInGroup(checkObject)

  for i,object in ipairs(self.objectList) do
    if object == checkObject then return true end
  end

end

function Group:remove(objectToRemove)

  if type(objectToRemove) == 'number' then
    table.remove(self.objectList, objectToRemove)
  elseif type(objectToRemove) == 'table' then
    for i,object in ipairs(self.objectList) do
      if object == objectToRemove then table.remove(self.objectList, i) end
    end
  end

end

function Group:getById(id)

  for i,object in ipairs(self.objectList) do
    if object.id == id then return object end
  end
  return nil

end

function Group:getObjectIndex(index)

  for i,object in ipairs(self.objectList) do
    if object == checkObject then return i end
  end

end

function Group:getByIndex(index)

  return self.objectList[index]

end

function Group:getAll()

  return self.objectList

end

return Group
