import { ChangeDetectionStrategy, Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { inject } from '@angular/core';
import { WeatherForecastService } from '../services/weather-forecast';
import { WeatherForecast } from '../models/weather-forecast';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-welcome',
  imports: [CommonModule],
  template: `
   <ul>
    @for (weatherForecast of weatherForecast$ | async; track $index) {
      <li>{{weatherForecast | json}}</li>
    }
  </ul>
  `,
  styleUrl: './welcome.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class Welcome implements OnInit {  
  weatherForecast$: Observable<WeatherForecast[]> | undefined;
  weatherForecastService = inject(WeatherForecastService);

  ngOnInit(): void {
    console.log("Init Welcome");
    this.weatherForecast$ = this.weatherForecastService.getWeatherForecast();
  }
}
