-- insert-media-links.lua
local function first_h1_index(blocks)
  for i, blk in ipairs(blocks) do
    if blk.t == "Header" and blk.level == 1 then return i end
  end
  return nil
end

function Pandoc(doc)
  local meta = doc.meta
  local yt = meta["youtube"] and pandoc.utils.stringify(meta["youtube"]) or nil
  local sp = meta["spotify"] and pandoc.utils.stringify(meta["spotify"]) or nil
  if not yt and not sp then return doc end

  local blocks = doc.blocks
  local idx = first_h1_index(blocks)
  local insert_at = idx and (idx + 1) or 1

  local items = {}

  if yt and #yt > 0 then
    local yt_url = "https://www.youtube.com/watch?v=" .. yt
    table.insert(items, { pandoc.Plain{ pandoc.Str("▶ "), pandoc.Link("Se på YouTube", yt_url) } })
  end

  if sp and #sp > 0 then
    local sp_type = meta["spotify-type"] and pandoc.utils.stringify(meta["spotify-type"]) or "track"
    local sp_url = "https://open.spotify.com/" .. sp_type .. "/" .. sp
    table.insert(items, { pandoc.Plain{ pandoc.Str("♫ "), pandoc.Link("Hør på Spotify", sp_url) } })
  end

  local div = pandoc.Div({ pandoc.BulletList(items) }, pandoc.Attr("", {"song-links"}))
  table.insert(blocks, insert_at, div)
  return pandoc.Pandoc(blocks, meta)
end
