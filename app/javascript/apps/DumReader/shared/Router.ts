import { BaseFetcher, ResponseJson } from '../../../shared/BaseFetcher'

export class Router extends BaseFetcher {
  getEntries = (): ResponseJson => {
    const url = '/api/v1/entries.json'
    return this.sendRequest(url, 'GET')
  }

  updateState = (state, ids): void => {
    const body = { state: state, ids: ids }
    const url = '/api/v1/entries.json'
    this.sendRequest(url, 'POST', body)
  }

  archive(ids): void {
    this.updateState('archived', ids)
  }

  save(ids): void {
    this.updateState('saved', ids)
  }

  markUnread(ids): void {
    this.updateState('unread', ids)
  }
}
