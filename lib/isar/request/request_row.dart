import 'package:anytimeworkout/isar/request/request_isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

class RequestRow extends IsarServices {
  Future<void> saveRequest(RequestIsar request) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.requestIsars.put(request);
    });
  }

  updateStatus(int createdAt) async {
    final isar = await db;
    final requestResult = await isar.requestIsars
        .filter()
        .statusLessThan(3)
        .createdAtLessThan(createdAt)
        .findAll();
    if (requestResult.isNotEmpty) {
      requestResult.forEach((element) {
        RequestIsar updateStatusRow = element;
        updateStatusRow.status = 3;
      });
      await isar.writeTxn(() async {
        await isar.requestIsars.putAll(requestResult);
      });
    }
  }

  // update request when admin changes in request.
  updateRequest(
    dynamic data,
    String serverId,
  ) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.requestIsars.putAll(data);
    });
  }

  // Update request when request notification will receive immediate after request add.
  updateRequestIdOnly(
      int createdAt, int updatedAt, String serverId, String requestId) async {
    final isar = await db;
    final requestResult = await isar.requestIsars
        .filter()
        .serverIdEqualTo('0')
        .idEqualTo(requestId)
        .findFirst();
    if (requestResult == null) return;
    if (requestResult.id!.isNotEmpty) {
      await isar.writeTxn(() async {
        RequestIsar updateStatusRow = requestResult;
        updateStatusRow.serverId = serverId;
        await isar.requestIsars.put(updateStatusRow);
      });
    }
  }

  Future<int> totalRequestCount() async {
    final isar = await db;
    final result = await isar.requestIsars.count();
    return result;
  }

  Future<int> fetchLastUpdatedRequest() async {
    final isar = await db;
    final result = await isar.requestIsars
        .filter()
        .locationIsNotEmpty()
        .sortByUpdatedAtDesc()
        .findFirst();
    if (result != null) {
      return result.updatedAt;
    } else {
      return 0;
    }
  }

  Future<List<RequestIsar>> fetchSavedRequests(
      {int offset = 0, int limit = 15}) async {
    final isar = await db;
    final result = await isar.requestIsars
        .filter()
        .locationIsNotEmpty()
        .sortByCreatedAtDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
    return result;
  }

  Future<List<RequestIsar>> fetchWithServerIdZero() async {
    final isar = await db;
    final result =
        await isar.requestIsars.filter().serverIdEqualTo('0').findAll();
    return result;
  }

  Future<List<RequestIsar>> fetchSavedRequestsOrderByTimeDesc(
      {int limit = 15, int updatedTime = 0}) async {
    final isar = await db;
    final result = await isar.requestIsars
        .filter()
        .updatedAtLessThan(updatedTime)
        .sortByCreatedAtDesc()
        .limit(limit)
        .findAll();
    return result;
  }

  Future<RequestIsar?> getRequestById(String requestId) async {
    final isar = await db;
    Id isarId = fastHash(requestId);
    RequestIsar? result = await isar.requestIsars.get(isarId);
    return result;
  }

  requestDeleteById(String requestId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.requestIsars.deleteById(requestId);
    });
  }

  Future<int> getTotalLength() async {
    final isar = await db;
    int totalCount = 0;
    await isar.writeTxn(() async {
      dynamic getCount =
          await isar.requestIsars.filter().locationIsNotEmpty().findAll();
      totalCount = getCount.length;
    });
    return totalCount;
  }

  deleteRequests() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.requestIsars.clear();
    });
  }
}
