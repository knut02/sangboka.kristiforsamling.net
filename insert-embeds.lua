-- insert-embeds.lua

function Pandoc(doc)
  local blocks = doc.blocks
  local meta   = doc.meta

  for i, blk in ipairs(blocks) do
    if blk.t == "Header" and blk.level == 1 then
      local inserts = {}

      -- YouTube
      if meta["youtube"] then
        local yt = pandoc.utils.stringify(meta["youtube"])
        local html_yt = string.format([[
<div class="video-container" style="margin-bottom:1em;">
  <iframe width="560" height="315"
    src="https://www.youtube.com/embed/%s"
    title="YouTube video player" frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen>
  </iframe>
</div>
]], yt)
        table.insert(inserts, pandoc.RawBlock("html", html_yt))
      end

      -- Spotify
      if meta["spotify-id"] then
        local sp = pandoc.utils.stringify(meta["spotify-id"])
        local html_sp = string.format([[
<div class="spotify-container" style="margin-bottom:1em;">
  <iframe src="https://open.spotify.com/embed/track/%s"
    width="300" height="380" frameborder="0"
    allow="encrypted-media">
  </iframe>
</div>
]], sp)
        table.insert(inserts, pandoc.RawBlock("html", html_sp))
      end

      -- injiser alle embeds i én slurk, i korrekt rekkefølge
      for j = #inserts, 1, -1 do
        table.insert(blocks, i+1, inserts[j])
      end

      break  -- bare én gang per dokument
    end
  end

  return pandoc.Pandoc(blocks, doc.meta)
end
