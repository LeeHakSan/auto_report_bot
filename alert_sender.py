"""로그인 경보 전송기 — n8n Webhook 으로 경보 JSON 을 POST 한다.

n8n 주소는 비밀이 아니지만(사내망 URL), 그래도 .env 로 관리해 환경마다
(로컬/도커/서버) 코드 수정 없이 바꿔 끼울 수 있게 한다.
"""
import os

import requests
from dotenv import load_dotenv

load_dotenv()

# ── 상수 (코드 맨 위 선언) ──
N8N_WEBHOOK_URL = os.environ.get('N8N_WEBHOOK_URL', '')
STUDENT_NAME = '이학산'


def build_payload():
  """레벨 10 이상(거부) 1건 + 10 미만(허용) 1건, 총 2건 이상."""
  return {
      'student': STUDENT_NAME,
      'alerts': [
          {'ip': '203.0.113.10', 'level': 10, 'rule': '5712'},
          {'ip': '198.51.100.7', 'level': 3, 'rule': '1234'},
      ],
  }


def send_alert(payload):
  """n8n Webhook 으로 POST. 실패해도 프로그램은 종료되지 않는다."""
  if not N8N_WEBHOOK_URL:
    print('[오류] N8N_WEBHOOK_URL 이 설정되어 있지 않습니다 (.env 확인).')
    return

  try:
    res = requests.post(N8N_WEBHOOK_URL, json=payload, timeout=5)
    res.raise_for_status()
    print(f'[전송 성공] status={res.status_code} body={res.text[:200]}')
  except requests.exceptions.RequestException as e:
    print(f'[전송 실패] n8n Webhook 호출 중 오류: {e}')


if __name__ == '__main__':
  send_alert(build_payload())
