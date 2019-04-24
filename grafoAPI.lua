--[[
API de criação de grafos usando Lua5.3 com orientação à objetos. Permite a criação de grafos simples unidirecionados e bidirecionados através de comandos simples de adição e remoção de vértices e arestas.

Correções a implantar:
- Fazer com que um método possa chamar outro;
- Usar strings para identificar os vértices, ao invés de seus índices;
- Corrigir o método para remover vértices.

Feito por Felipe Oliveira - 2019 - UFPA.
]]--
--importa as funções de busca
local search = require "grafoDFS"

--meta classe Grafo
Grafo = {
	vertices,
	arestas,
	lacos,
	listaAdj
}

--cria um novo grafo
function Grafo:new(o, vertice)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.vertices = vertice or 0
	self.arestas = 0
	self.lacos = 0
	self.listaAdj = {}
	for i=1,vertice do
		self.listaAdj[i] = {}
	end
	return o
end

--lista o grafo, contando a qte de vertices, arestas e as relações entre os vértices
function Grafo:imprimir()
	print("\nNúmero de vértices: "..self.vertices)
	print("número de arestas: "..self.arestas)
	print("Número de laços: "..self.lacos)
	print(string.format("\nLista de Adjacência:\n=============="))
	for i=1, #self.listaAdj do
		io.write("["..i.."]")
		for j=1, #self.listaAdj[i] do
			io.write("->["..self.listaAdj[i][j].."]")
		end
		print()
	end
	print(string.format("==============\n"))
end

--adiciona um vértice ao grafo
function Grafo:addVertice()
	self.vertices = self.vertices + 1
	table.insert(self.listaAdj, {})
	print("vértice adicionado.")
end

--remove um vértice v do grafo(consertar)
function Grafo:removeVertice(v)
	table.remove(self.listaAdj, v)
	self.vertices = self.vertices - 1
	for i=1, #self.listaAdj do
		--remover todas as arestas associadas com o vértice removido.
	end
end

--adiciona a aresta vw no grafo (unidirecional)
function Grafo:addEdgeUni(v, w)
	if v > #self.listaAdj or w > #self.listaAdj then
		print("Este vértice não existe!")
		return
	else
		if v==w then
			self.lacos = self.lacos + 1
			self.arestas = self.arestas + 2
		else
			table.insert(self.listaAdj[v], w)
			self.arestas = self.arestas + 1
		end
		table.sort(self.listaAdj[v])
		print("aresta "..v.."-"..w.." adicionada.")
	end
end

--adiciona a aresta vw no grafo (bidirecional)
function Grafo:addEdgeBi(v, w)
	if v > #self.listaAdj or w > #self.listaAdj then
		print("Este vértice não existe!")
		return
	else
		if v==w then
			table.insert(self.listaAdj[v], w)
			self.lacos = self.lacos + 1
			self.arestas = self.arestas + 2
		else
			table.insert(self.listaAdj[v], w)
			table.insert(self.listaAdj[w], v)
			self.arestas = self.arestas + 1
		end
		table.sort(self.listaAdj[v])
		print("aresta "..v.."-"..w.." adicionada.")
	end
end

--remove a aresta vw do grafo(unidirecional)
function Grafo:removeEdgeUni(v, w)
	if v == w then
		table.remove(self.listaAdj[v],v)
		self.arestas = self.arestas - 2
	else	
		table.remove(self.listaAdj[v], w)
		self.arestas = self.arestas - 1
	end
	print("aresta removida.")
end

--remove a aresta vw do grafo(bidirecional)
function Grafo:removeEdgeBi(v, w)
	if v == w then
		table.remove(self.listaAdj[v],v)
		self.arestas = self.arestas - 2
	else
		table.remove(self.listaAdj[v], w)
		table.remove(self.listaAdj[w], v)
		self.arestas = self.arestas - 1
	end
	print("aresta removida.")
end

--retorna o grau de um vértice
function Grafo:grau(v)
	return #self.listaAdj[v]
end

--retorna o vértice com grau máximo de um grafo
function Grafo:maxGrau()
	max = 0
	for i=1, #self.listaAdj do
		if #self.listaAdj[i] > max then
			max = i
		end
	end
	return max
end

--verifica quantos laços (loops) tem um grafo
function Grafo:loop()
	--[[nLacos = 0
	for i=1, #self.listaAdj do
		for j=1, #self.listaAdj[i] do
		--print(self.listaAdj[i][j])
			if i == self.listaAdj[i][j] then
				nLacos = nLacos + 1
			end
		end
	end
	return nLacos]]--
	return self.lacos
end

--verifica se um gráfico possui caminho euleriano
function Grafo:verificaEuler()
	for i=1, #self.listaAdj do
	grauVertice = #self.listaAdj[i]
		if grauVertice % 2 ~= 0 or #self.listaAdj[i]==0 then
			return false
		end
	end
	return true
end

--verifica se um gráfico possui caminho euleriano aberto
function Grafo:verificaEulerAberto()
	verticesImpares = 0
	for i=1, #self.listaAdj do
		grauVertice = #self.listaAdj[i]
		if #self.listaAdj[i]==0 then
			return false
		end
		if grauVertice % 2 ~= 0 then
			verticesImpares = verticesImpares + 1
		end
	end
	if verticesImpares == 2 then
		return true
	else
		return false
	end
end

--Busca em profundidade (DFS)
--variáveis globais necessárias
cor = {}
d = {}
f = {}
pi = {}
function Grafo:dfs()
	for i=1, #self.listaAdj do
		table.insert(cor, "branco")
		pi[i] = {nil}
		d[i] = 0
		f[i] = 0
		--table.insert(tempo.d[i], {})
		--[[for j=1, #self.listaAdj[i] do
			cor[i][j] = "branco"
			pi[i][j] = nil
		end]]
	end
	tempo = 0
	for i=1, #self.listaAdj do
		if cor[i] == "branco" then
			self.dfsVisita(i)
		end
	end
	print("OK")
end

function Grafo:dfsVisita(i)
	cor[i] = "cinza"
	tempo = tempo + 1
	d[i] = tempo
	for v=1, #self.listaAdj[i] do
		if cor[v] == "branco" then
			pi[v] = i
			dfsVisita(v)
		end
	end
	cor[i] = "preto"
	f[i] = tempo + 1
end

G = Grafo:new(nil, 5)
search.dfs(G)
search.bfs(G, 1)
--[[G:imprimir()
G:addEdgeBi(1,2)
G:addEdgeBi(4,2)
G:addEdgeBi(2,2)
G:addEdgeBi(2,3)
G:dfs()]]