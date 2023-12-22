import 'package:sapo_benefica/data/api/get/api_get_table_format.dart';
import 'package:sapo_benefica/data/api/post/api_post_create_anulment_client.dart';
import 'package:sapo_benefica/data/api/post/api_post_create_client.dart';
import 'package:sapo_benefica/data/api/post/api_post_create_client_asesoria.dart';
import 'package:sapo_benefica/data/api/post/api_post_create_incorrect_debit_client.dart';
import 'package:sapo_benefica/data/api/post/api_post_generate_anulment_file.dart';
import 'package:sapo_benefica/data/api/post/api_post_generate_credit.dart';
import 'package:sapo_benefica/data/api/post/api_post_generate_files.dart';
import 'package:sapo_benefica/data/api/post/api_post_generate_files_backend.dart';
import 'package:sapo_benefica/data/api/post/api_post_points_user.dart';
import 'package:sapo_benefica/data/api/post/api_post_query_client_in_mufasa.dart';
import 'package:sapo_benefica/data/api/post/api_post_query_persona.dart';
import 'package:sapo_benefica/data/api/post/api_post_generate_debit.dart';
import 'package:sapo_benefica/data/api/get/api_post_select_diptico.dart';
import 'package:sapo_benefica/data/api/post/api_post_query_points.dart';
import 'package:sapo_benefica/data/api/update/api_update_anulment_client.dart';
import 'package:sapo_benefica/data/api/update/api_update_client.dart';
import 'package:sapo_benefica/data/api/update/api_update_client_benefit.dart';
import 'package:sapo_benefica/data/api/update/api_update_incorrect_debit_client.dart';
import 'package:sapo_benefica/data/api/update/api_update_points_user.dart';

class AWSRepository {
  static queryPersona(String numCed) {
    return ApiQueryPersona.queryPersona(numCed);
  }

  static generateDebit(String numCed, String cuenta, String valor) {
    return ApiGenerateDebit.generateDebit(numCed, cuenta, valor);
  }

    static generateCredit(String numCed, String cuenta, String valor) {
    return ApiGenerateCredit.generateCredit(numCed, cuenta, valor);
  }

  static queryClientInMufasa(String numCed) {
    return ApiQueryClientInMufasa.queryClientInMufasa(numCed);
  }

  static selectDiptico(String numCed) {
    return ApiSelectDiptico.selectDiptico(numCed);
  }

  static queryPoints(String plan, String transaccion) {
    return ApiQueryPoints.queryPoints(plan, transaccion);
  }

  static createClientAsesoria(Map<String, dynamic> data) {
    return ApiCreateClientAsesoria.createClientAsesoria(data);
  }

  static updateClientBenefit(Map<String, dynamic> data) {
    return ApiUpdateClientBenefit.updateBenefit(data);
  }

  static updateAnulmentClient(Map<String, dynamic> data) {
    return ApiUpdateAnulmentClient.updateAnulmentClient(data);
  }

  static createAnulmentClient(Map<String, dynamic> data) {
    return ApiCreateAnulmentClient.createAnulmentClient(data);
  }

  static generateAnulmentFile(Map<String, dynamic> data) {
    return ApiGenerateAnulmentFile.generateAnulmentFile(data);
  }

    static signAnulmentFile(Map<String, dynamic> data) {
    return ApiGenerateAnulmentFile.signAnulmentFile(data);
  }


  static createClient(Map<String, dynamic> data) {
    return ApiCreateClient.createClient(data);
  }

  static updateClient(Map<String, dynamic> data) {
    return ApiUpdateClient.updateClient(data);
  }

  static createIncorrectDebitClient(Map<String, dynamic> data) {
    return ApiCreateIncorrectDebitClient.createIncorrectDebitClient(data);
  }

  static updateIncorrectDebitClient(Map<String, dynamic> data) {
    return ApiUpdateIncorrectDebitClient.updateIncorrectDebitClient(data);
  }

  static pointsUser(String email) {
    return ApiPointsUser.pointsUser(email);
  }

  static updatePointsUser(String userId, int points) {
    return ApiUpdatePointsUser.updatePointsUser(userId, points);
  }

  static getTableFormat() {
    return ApiGetTableFormat.getTableFormat();
  }

  static generateFiles(Map<String, dynamic> data) {
    // return NewApiGenerateFiles.generateFiles(data);
    return ApiGenerateFiles.generateFiles(data);
  }

  static sendEmail(Map<String, dynamic> data) {
    return ApiGenerateFiles.sendEmail(data);
  }

  /* static updateBenefit(Map<String, dynamic> data) {
    return ApiUpdateClientBenefit.updateBenefit(data);
  }

  static updateClientBenefit(Map<String, dynamic> data) {
    return ApiUpdateClientBenefit.updateBenefit(data);
  } */

  static generateCertificate(Map<String, dynamic> data) {
    return ApiUpdateClientBenefit.generateCertificate(data);
  }
}
