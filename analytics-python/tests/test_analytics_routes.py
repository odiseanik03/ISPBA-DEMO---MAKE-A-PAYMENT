from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_run_daily_report_endpoint(monkeypatch) -> None:
    called = {"count": 0}

    def _fake_generate():
        called["count"] += 1

    monkeypatch.setattr("app.api.routes_analytics._daily.generate", _fake_generate)

    response = client.post("/analytics/run/daily-report")

    assert response.status_code == 200
    assert response.json() == {"status": "accepted", "job": "daily-report"}
    assert called["count"] == 1


def test_run_data_quality_endpoint(monkeypatch) -> None:
    called = {"count": 0}

    def _fake_run():
        called["count"] += 1

    monkeypatch.setattr("app.api.routes_analytics._dq.run", _fake_run)

    response = client.post("/analytics/run/data-quality")

    assert response.status_code == 200
    assert response.json() == {"status": "accepted", "job": "data-quality"}
    assert called["count"] == 1


def test_run_risk_check_endpoint(monkeypatch) -> None:
    called = {"count": 0}

    def _fake_run():
        called["count"] += 1

    monkeypatch.setattr("app.api.routes_analytics._risk.run", _fake_run)

    response = client.post("/analytics/run/risk-check")

    assert response.status_code == 200
    assert response.json() == {"status": "accepted", "job": "risk-check"}
    assert called["count"] == 1
