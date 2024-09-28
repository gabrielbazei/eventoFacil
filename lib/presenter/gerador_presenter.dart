abstract class GenerateQRCodeView {
  void updateQRCode(String qrData);
}

class GenerateQRCodePresenter {
  final GenerateQRCodeView view;

  GenerateQRCodePresenter(this.view);

  // Método para obter o QR code (pode ser estendido para buscar de um servidor, etc.)
  void loadQRCode() {
    // Simula a recuperação do ID do aluno
    String id = '123';
    view.updateQRCode(id);
  }
}
