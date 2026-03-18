import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { WeatherForecast } from '../models/weather-forecast';
import { Observable } from 'rxjs';
@Injectable({
    providedIn: 'root'
})
export class WeatherForecastService {
    constructor(private httpClient: HttpClient) { }
    getWeatherForecast(): Observable<WeatherForecast[]> {
        return this.httpClient.get<WeatherForecast[]>('api/weatherforecast');
    }
}