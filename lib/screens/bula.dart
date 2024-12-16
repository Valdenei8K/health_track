import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';  // Importando o pacote Syncfusion
import 'dart:typed_data';
import '../widget/default_layout.dart';
import '../widget/textFormField.dart';
import '../widget/text_labels.dart';
import '../models/produto_model.dart'; // Importando o modelo Produto

class BulaApp extends StatefulWidget {
  const BulaApp({super.key});

  @override
  _BulaAppState createState() => _BulaAppState();
}

class _BulaAppState extends State<BulaApp> {
  final TextEditingController _searchController = TextEditingController();
  List<Produto> produtos = [];
  bool isLoading = false;

  Future<void> fetchProdutos(String nomeProduto) async {
    if (nomeProduto.isEmpty) {
      setState(() {
        produtos = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://consultas.anvisa.gov.br/api/consulta/bulario?count=10&filter%5BnomeProduto%5D=$nomeProduto&page=1'),
        headers: {
          "accept": "application/json, text/plain, */*",
          "accept-language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
          "authorization": "Guest",
          "cache-control": "no-cache",
          "if-modified-since": "Mon, 26 Jul 1997 05:00:00 GMT",
          "pragma": "no-cache",
          "sec-ch-ua-mobile": "?0",
          "sec-ch-ua-platform": "\"Windows\"",
          "sec-fetch-dest": "empty",
          "sec-fetch-mode": "cors",
          "sec-fetch-site": "same-origin",
          "cookie": "FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; _pk_id.42.210e=8eca716434ce3237.1690380888.; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; _cfuvid=L.SzxLLxZoWYrYqhaiRgS5MTkV77mwE5uIyLNWvyufk-1690462598410-0-604800000; _pk_ref.42.210e=%5B%22%22%2C%22%22%2C1690462669%2C%22https%3A%2F%2Fwww.google.com%2F%22%5D; _pk_ses.42.210e=1; cf_clearance=tk5QcLSYPlUQfr8s2bTGXyvC2KZdHcEIYU8r6HCgNvQ-1690462689-0-160.0.0",
          "Referer": "https://consultas.anvisa.gov.br/",
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
          "Referrer-Policy": "no-referrer-when-downgrade",
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> content = data['content'];
      setState(() {
        produtos = content.map((e) => Produto.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Erro ao carregar os produtos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Buscar Bula',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildText('Digite o nome do medicamento'),
            buildTextField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              hintText: 'Exemplo: Paracetamol',
              prefixIcon: Icon(Icons.search),
              onChanged: (value) {
                fetchProdutos(value);
              },
            ),
            // TextField(
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: produtos.isEmpty
                  ? Center(
                child: Text(
                  'Nenhum produto encontrado. Tente outra busca.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  final produto = produtos[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProdutoDetalhesPage(produto: produto),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(produto.nomeProduto,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Registro: ${produto.numeroRegistro}', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text('Razão Social: ${produto.razaoSocial}', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text('Data de Atualização: ${produto.dataAtualizacao}', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProdutoDetalhesPage extends StatefulWidget {
  final Produto produto;

  ProdutoDetalhesPage({required this.produto});

  @override
  _ProdutoDetalhesPageState createState() => _ProdutoDetalhesPageState();
}

class _ProdutoDetalhesPageState extends State<ProdutoDetalhesPage> {
  bool isLoading = false;
  Uint8List? pdfBytes;

  // Função para fazer o download do PDF
  Future<void> downloadPDF(String idPacienteProtegido) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
      'https://consultas.anvisa.gov.br/api/consulta/medicamentos/arquivo/bula/parecer/$idPacienteProtegido/?Authorization=Guest',
    );

    final response = await http.get(url, headers: {
      "accept": "application/json, text/plain, */*",
      "accept-language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
      "authorization": "Guest",
      "cache-control": "no-cache",
      "if-modified-since": "Mon, 26 Jul 1997 05:00:00 GMT",
      "pragma": "no-cache",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "cookie": "FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; _pk_id.42.210e=8eca716434ce3237.1690380888.; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; _cfuvid=L.SzxLLxZoWYrYqhaiRgS5MTkV77mwE5uIyLNWvyufk-1690462598410-0-604800000; _pk_ref.42.210e=%5B%22%22%2C%22%22%2C1690462669%2C%22https%3A%2F%2Fwww.google.com%2F%22%5D; _pk_ses.42.210e=1; cf_clearance=tk5QcLSYPlUQfr8s2bTGXyvC2KZdHcEIYU8r6HCgNvQ-1690462689-0-160.0.0",
      "Referer": "https://consultas.anvisa.gov.br/",
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
      "Referrer-Policy": "no-referrer-when-downgrade",
    });

    if (response.statusCode == 200) {
      setState(() {
        pdfBytes = response.bodyBytes;  // Armazena os bytes do PDF
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Erro ao baixar o PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.produto.nomeProduto)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do Produto: ${widget.produto.nomeProduto}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Número de Registro: ${widget.produto.numeroRegistro}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Razão Social: ${widget.produto.razaoSocial}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('CNPJ: ${widget.produto.cnpj}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Processo: ${widget.produto.numProcesso}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Data de Atualização: ${widget.produto.dataAtualizacao}', style: TextStyle(fontSize: 12)),
            SizedBox(height: 20),
            // Botão para baixar o PDF
            ElevatedButton(
              onPressed: () {
                downloadPDF(widget.produto.idPacienteProtegido);  // Usando idPacienteProtegido
              },
              child: Text("Baixar Bula em PDF"),
            ),
            SizedBox(height: 20),
            // Exibe o PDF usando o Syncfusion PDFViewer
            isLoading
                ? Center(child: CircularProgressIndicator())
                : pdfBytes != null
                ? Expanded(  // Usando Expanded para garantir que o PDF ocupe o espaço disponível
                child: SfPdfViewer.memory(pdfBytes!)  // Exibe o PDF a partir dos bytes
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
