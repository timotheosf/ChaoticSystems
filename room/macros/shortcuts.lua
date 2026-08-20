return {
  ['MakeChapter'] = function(args, kwargs)
    local numbering = pandoc.utils.stringify(kwargs["numbering"] or "")
    local titulo = pandoc.utils.stringify(kwargs["titulo"] or "Título")
    local desc = pandoc.utils.stringify(kwargs["desc"] or "")
    local img = pandoc.utils.stringify(kwargs["img"] or "")
    
    -- TEMPLATE: É crucial que os :::: fiquem colados na margem esquerda!
    local template = [[
::::: {.capitulo-grid}
:::: {.capitulo-textos}
:::: {.capitulo-textos}
::::
<div class="NumberingGradient" style="margin-bottom: 10px;"> %s</div>
<div style="display: flex; align-items: flex-end; margin-bottom: 30px;">
  <h1 class="titulo-principal"> %s </h1>
</div>
<div class="desc"> %s </div>

::::

:::: {.capitulo-imagem}
![](%s)
::::
:::::
]]
    
    local markdown_final = string.format(template, numbering, titulo, desc, img)
    
    -- O Segredo: Usamos o pandoc.read para "parsear" o texto e injetar os blocos de verdade na apresentação
    return pandoc.read(markdown_final).blocks
  end
}