import 'package:flutter/material.dart';

class PolicyPrivacyPage extends StatefulWidget {
  const PolicyPrivacyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPrivacyPage> createState() => _PolicyPrivacyState();
}

class _PolicyPrivacyState extends State<PolicyPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(100, 3, 169, 244),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/icon.png'),
              width: 40,
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              'Politica de privacidade',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Política de Privacidade do Text Detector MLKit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Última atualização: 06/06/2025',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 24),
              Text(
                '1. Introdução',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'O Text Detector MLKit é um aplicativo que utiliza o ML Kit do Google para detecção de textos em imagens. '
                'Esta política descreve como seus dados são tratados, garantindo transparência e conformidade com as diretrizes do Google.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Coleta de Dados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '2.1 Processamento pelo ML Kit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('- O reconhecimento de texto ocorre localmente (on-device).'),
              Text('- Nenhuma imagem ou texto é enviado a servidores externos.'),
              Text('- Dados processados não são armazenados após o uso.'),
              SizedBox(height: 8),
              Text(
                '2.2 Permissões Requeridas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Câmera: Capturar imagens em tempo real.'),
              Text('• Armazenamento: Ler imagens da galeria.'),
              Text('• Internet (Opcional): Atualizações e análises (se aplicável).'),
              SizedBox(height: 8),
              Text(
                '2.3 Dados Opcionais',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('- Dados de diagnóstico (logs): Coletados apenas com consentimento para melhorias.'),
              Text('- Informações do dispositivo (modelo, SO): Usadas para compatibilidade.'),
              SizedBox(height: 16),
              Text(
                '3. Uso dos Dados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('- Funcionalidade principal: Extração de texto apenas no dispositivo.'),
              Text('- Melhorias no app: Análise de erros (dados anônimos).'),
              Text('- Nenhum dado pessoal é compartilhado ou vendido.'),
              SizedBox(height: 16),
              Text(
                '4. Compartilhamento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('- Zero compartilhamento de textos/imagens detectados.'),
              Text('- Dados agregados (estatísticas) podem ser usados para análise (ex.: Firebase Analytics).'),
              SizedBox(height: 16),
              Text(
                '5. Segurança',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('🔒 Processamento 100% local (sem cloud).'),
              Text('Dados salvos (se optar) ficam apenas no seu dispositivo.'),
              SizedBox(height: 16),
              Text(
                '6. Alterações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Atualizações serão comunicadas via:'),
              Text('- Notificação no app.'),
              Text('- Aviso na página do app na Play Store.'),
              SizedBox(height: 16),
              Text(
                '7. Seus Direitos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('- Revogar permissões (via configurações do dispositivo).'),
              Text('- Solicitar exclusão de dados (se aplicável).'),
              SizedBox(height: 16),
              Text(
                '8. Contato',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Dúvidas? Envie um e-mail para:'),
              SizedBox(height: 8),
              Text('📧 davigomesflorencio@gmail.com', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
