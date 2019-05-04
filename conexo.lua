--cria a tabela conexo, com suas variáveis e funções
conexo = {}

conexo.marcado = {}
conexo.id = {}
conexo.cont = 0

function conexo.comp_conectados(grafo)
    conexo.marcado[1] = true
    --conexo.id
	for s=1, #grafo.listaAdj do
		if conexo.marcado[s]~=true then
			conexo.conectado_p2(grafo, s)
			conexo.cont = conexo.cont + 1
		end
    end
    print("componetes conexos: "..conexo.cont)
end

function conexo.conectado_p2(grafo, v)
	conexo.marcado[v] = true
	conexo.id[v] = conexo.cont
	for w=1, #grafo.listaAdj do
		if conexo.marcado[w]~=true then
			conexo.conectado_p2(grafo, w)
		end
    end
    
end

function conexo.conectado(v, w)
	return conexo.id[v]==conexo.id[w]
end

return conexo