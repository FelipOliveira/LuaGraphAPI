--importa as funções para a fila
queue = require "Fila"

busca = {} 
--variáveis globais necessárias
busca.cor = {}
busca.d = {}
busca.f = {}
busca.pi = {}


function busca.dfs(grafo)
	for i=1, #grafo.listaAdj do --percorre todos os vértices
		cor[i] = "branco" --pinta os vértice de branco
		pi[i] = {nil} --define o vértice anterior como nulo
		d[i] = 0
		f[i] = 0
		--table.insert(tempo.d[i], {})
		--[[for j=1, #grafo.listaAdj[i] do
			cor[i][j] = "branco"
			pi[i][j] = nil
		end]]
	end
	tempo = 0
	for i=1, #grafo.listaAdj do
		if cor[i] == "branco" then
			busca.dfsVisita(grafo, i)
		end
	end
    --print("dfs ok")
end

function busca.dfsVisita(grafo, i)
	cor[i] = "cinza"
	tempo = tempo + 1
	d[i] = tempo
	for v=1, #grafo.listaAdj[i] do
		if cor[v] == "branco" then
			pi[v] = i
			dfsVisita(grafo, v)
		end
	end
	cor[i] = "preto"
	f[i] = tempo + 1
end

function busca.bfs(grafo, s)
    --Define para todos os vértices, menos a fonte: cor, distância do veŕtice em relação à fonte e o vértice antecessor
    for u=1, #grafo.listaAdj do
        if u ~= s then
            cor[u] = "branco"
            d[u] = nil
            pi[u] = nil
        end
    end
    cor[s] = "cinza"
    d[s] = 0
    pi[s] = nil --o vértice fonte não tem antecessor
    Q = queue.new() --cria uma nova fila
    queue.coloca(Q, s)
    while Q.first < Q.last do
        u = queue.retira(Q)
        for v=1, #grafo.listaAdj[u] do
            if cor[v] == "branco" then
                cor[v] = "cinza"
                d[v] = d[u] + 1
                pi[v] = u
                queue.coloca(Q, v)
            end
        end
        cor[u] = "preto"
    end
    --print("bfs ok")
end

return busca