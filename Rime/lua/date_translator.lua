local function date_translator(input, seg)
  if (input == "date") then
    return yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
  elseif (input == "time") then
    return yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), ""))
  else
    return nil
  end
end
return date_translator
